class CloudFileIngesterJob < ApplicationJob
  queue_as :default

  def perform(path_to_item, bucket, options={})
    cloud_file = CloudFileUploaderService.upload path_to_file, bucket, options
    tagger = Tagger::Factory.generate(cloud_file)
    tagger.identify_and_update!(cloud_file)
    cloud_file
  end
end
