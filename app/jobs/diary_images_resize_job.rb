class DiaryImagesResizeJob < ApplicationJob
  queue_as :default

  def perform(diary)
    diary.images.each do |image|
      image.variant(resize_to_limit: [350,350]).processed
      image.variant(resize_to_limit: [150,150]).processed
      image.variant(resize_to_limit: [100,100]).processed
    end
  end
end
