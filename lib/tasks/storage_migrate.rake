# frozen_string_literal: true

module ActiveStorage
  class Downloader
    def initialize(blob, tempdir: nil)
      @blob    = blob
      @tempdir = tempdir
    end

    def download_blob_to_tempfile
      open_tempfile do |file|
        download_blob_to file
        verify_integrity_of file
        yield file
      end
    end

    private

      attr_reader :blob, :tempdir

      def open_tempfile
        file = Tempfile.open(["ActiveStorage-#{blob.id}-", blob.filename.extension_with_delimiter], tempdir)

        begin
          yield file
        ensure
          file.close!
        end
      end

      def download_blob_to(file)
        file.binmode
        blob.download { |chunk| file.write(chunk) }
        file.flush
        file.rewind
      end

      def verify_integrity_of(file)
        raise ActiveStorage::IntegrityError unless Digest::MD5.file(file).base64digest == blob.checksum
      end
  end
end

module AsDownloadPatch
  def open(tempdir: nil, &block)
    ActiveStorage::Downloader.new(self, tempdir: tempdir).download_blob_to_tempfile(&block)
  end
end

Rails.application.config.to_prepare do
  ActiveStorage::Blob.send(:include, AsDownloadPatch)
end

def migrate(from, to)
  configs = Rails.configuration.active_storage.service_configurations
  from_service = ActiveStorage::Service.configure from, configs
  to_service   = ActiveStorage::Service.configure to, configs

  ActiveStorage::Blob.service = from_service

  puts "#{ActiveStorage::Blob.count} Blobs to go..."

  ActiveStorage::Blob.find_each do |blob|
    print "."
    file = Tempfile.new("file#{Time.now}")
    file.binmode
    file << blob.download
    file.rewind
    checksum = blob.checksum
    to_service.upload(blob.key, file, checksum: checksum)
  rescue Errno::ENOENT
    puts "Rescued by Errno::ENOENT statement. ID: #{blob.id} / Key: #{blob.key}"
    next
  rescue ActiveStorage::FileNotFoundError
    puts "Rescued by FileNotFoundError. ID: #{blob.id} / Key: #{blob.key}"
    next
  end
end

namespace :storage do
  desc "Migrate ActiveStorage files from local to Amazon S3"
  task migrate: :environment do
    migrate(:local, :qiniu)
  end
end
