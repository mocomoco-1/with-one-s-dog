# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 10
  # config.max_per_page = nil
  # 現在のページの前後に表示するページ数
  config.window = 2
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
