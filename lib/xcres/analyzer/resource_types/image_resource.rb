require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all images.
    #
    class ImageResource < BaseResource

      def self.filter_words
        return ['icon', 'image']
      end

      def self.filter_files file_paths
        filtered_files = super(file_paths)
        filtered_files.select { |path| path.to_s.match /\.(png|jpe?g|gif)$/ }
        return filter_device_specific_image_paths(filtered_files)
      end

      def self.resource_type
        return 'Images'
      end

      # Filter out device scale and idiom specific images (retina, ipad),
      # but ensure the base exist once
      #
      # @param  [Array<Pathname>] file_paths
      #         the file paths to filter
      #
      # @return [Array<String>]
      #         the filtered file paths
      #
      def self.filter_device_specific_image_paths file_paths
        file_paths.map do |path|
          path.to_s.gsub /(@2x)?(~(iphone|ipad))?(?=\.\w+$)/, ''
        end.to_set.to_a
      end
    end
  end
end