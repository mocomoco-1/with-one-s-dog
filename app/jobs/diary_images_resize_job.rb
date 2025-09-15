class DiaryImagesResizeJob < ApplicationJob
  queue_as :default

  def perform(diary)
    diary.images.each do |image|
      image.variant(resize_to_limit: [ 400, 400 ]).processed
      image.variant(resize_to_limit: [ 200, 200 ]).processed
      image.variant(resize_to_limit: [ 100, 100 ]).processed
    end
  end
end
