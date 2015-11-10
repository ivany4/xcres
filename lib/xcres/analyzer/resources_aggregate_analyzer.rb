require 'xcres/analyzer/aggregate_analyzer'
require 'xcres/analyzer/collections_analyzer/bundle_collections_analyzer'
require 'xcres/analyzer/collections_analyzer/loose_files_collections_analyzer'
require 'xcres/analyzer/collections_analyzer/xcassets_collections_analyzer'
require 'xcres/analyzer/resource_types/image_resource'
require 'xcres/analyzer/resource_types/sound_resource'
require 'xcres/analyzer/resource_types/arbitrary_xcasset_resource'
require 'xcres/analyzer/resource_types/image_xcasset_resource'

module XCRes

  # A +ResourcesAggregateAnalyzer+ scans the project for resources,
  # which should be included in the output file.
  #
  # It is a +AggregateAnalyzer+, which uses the following child analyzers:
  #  * +XCRes::ResourcesAnalyzer::BundleImageResourcesAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::LooseImageResourcesAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::XCAssetsAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::LooseSoundResourcesAnalyzer+
  #
  class ResourcesAggregateAnalyzer < AggregateAnalyzer

    def analyze
      self.analyzers = []
      add_with_class CollectionsAnalyzer::BundleCollectionsAnalyzer, { linked_resources: [ ResourceTypes::ImageResource.new, ResourceTypes::SoundResource.new ] }
      add_with_class CollectionsAnalyzer::XCAssetsCollectionsAnalyzer, { linked_resources: [ ResourceTypes::ImageXCAssetResource.new, ResourceTypes::ArbitraryXCAssetResource.new ] }
      add_with_class CollectionsAnalyzer::LooseFilesCollectionsAnalyzer, { linked_resources: [ ResourceTypes::ImageResource.new, ResourceTypes::SoundResource.new ] }
      super
    end
  end

end
