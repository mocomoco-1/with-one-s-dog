class DiaryImagesResizeJob < ApplicationJob
  queue_as :default

  def perform(diary)
    diary.images.each do |image|
      image.variant(resize_to_fill: [ 350, 350 ]).processed
      image.variant(resize_to_fill: [ 200, 200 ]).processed
      image.variant(resize_to_fill: [ 100, 100 ]).processed
    end
  end
end
