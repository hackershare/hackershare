# frozen_string_literal: true

module Hackershare
  # A ActiveStorage Blob helper
  # To convert image thumb name into Active Storage Variation
  #
  # https://github.com/thebluedoc/bluedoc/blob/7efc1c5c3878a4d63bcaed7294c87ff30dc2c2a7/lib/bluedoc/blob.rb
  class Blob
    class << self
      IMAGE_SIZES = { sm: 64, md: 150, lg: 440, xl: 1600 }

      # convert image thumb name into Active Storage Variation
      def variation(size)
        ActiveStorage::Variation.new(combine_options(size))
      end

      private

        def combine_options(size)
          size = size&.to_sym
          width = IMAGE_SIZES[size] || IMAGE_SIZES[:md]

          if size == :xl
            { resize: "#{width}>" }
          else
            { thumbnail: "#{width}x#{width}^", gravity: "center", extent: "#{width}x#{width}" }
          end
        end
    end
  end
end
