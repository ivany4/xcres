require 'xcres/analyzer/aggregate_analyzer'
require 'xcres/analyzer/collections_analyzer/bundle_collections_analyzer'
require 'xcres/analyzer/collections_analyzer/loose_files_collections_analyzer'
require 'xcres/analyzer/collections_analyzer/xcassets_collections_analyzer'
require 'xcres/analyzer/resource_types/image_resource'
require 'xcres/analyzer/resource_types/sound_resource'

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
      add_with_class CollectionsAnalyzer::BundleCollectionsAnalyzer, { linked_resource: ResourceTypes::ImageResource}
      add_with_class CollectionsAnalyzer::BundleCollectionsAnalyzer, { linked_resource: ResourceTypes::SoundResource}
      add_with_class CollectionsAnalyzer::XCAssetsCollectionsAnalyzer, { linked_resource: ResourceTypes::ImageResource}
      add_with_class CollectionsAnalyzer::XCAssetsCollectionsAnalyzer, { linked_resource: ResourceTypes::SoundResource}
      add_with_class CollectionsAnalyzer::LooseFilesCollectionsAnalyzer, { linked_resource: ResourceTypes::ImageResource}
      add_with_class CollectionsAnalyzer::LooseFilesCollectionsAnalyzer, { linked_resource: ResourceTypes::SoundResource}
      super
    end
  end

end
