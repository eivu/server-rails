class TaggerJob < ApplicationJob
  # throttle threshold: 3, period: 1.second#, drop: true
  throttle threshold: 1, period: 1.hour#, drop: true

  queue_as :tagging

  def perform(*args)
    # tagger = Tagger::Factory.generate(cloud_file)
    # tagger.identify_and_update!
    :car
  end
end
