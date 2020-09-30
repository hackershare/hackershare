# frozen_string_literal: true

class UploadsController < ActionController::Base
  before_action :set_blob

  # A customize uploads path for ActiveStorage
  #
  # GET /uplaods/:id?s=<size>
  #
  # send file
  #
  # Reference implementation
  # https://github.com/thebluedoc/bluedoc/blob/7efc1c5c3878a4d63bcaed7294c87ff30dc2c2a7/app/controllers/blobs_controller.rb
  def show
    send_file_by_disk_key @blob, content_type: @blob.content_type
  rescue ActionController::MissingFile, ActiveStorage::FileNotFoundError
    head :not_found
  rescue ActiveStorage::IntegrityError
    head :unprocessable_entity
  end

  private

    def send_file_by_disk_key(blob, content_type:)
      expires_in 1.year

      blob_key = blob.key

      if params[:s]
        blob_key = @blob.representation(Hackershare::Blob.variation(params[:s])).processed.key
      end

      blob_path = ActiveStorage::Blob.service.send(:path_for, blob_key)

      send_file blob_path, type: content_type, disposition: :inline
    end


    def set_blob
      @blob = Rails.cache.fetch("blobs:#{params[:id]}") do
        ActiveStorage::Blob.find_by(key: params[:id])
      end

      head :not_found if @blob.blank?
    end
end
