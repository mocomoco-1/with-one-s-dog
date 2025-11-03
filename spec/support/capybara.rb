Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-software-rasterizer')
  options.add_argument('--disable-background-timer-throttling')
  options.add_argument('--disable-renderer-backgrounding')
  options.add_argument('--disable-backgrounding-occluded-windows')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--remote-allow-origins=*')
  options.add_argument('user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

  # 重要：ユーザーデータディレクトリを無効化
  # options.add_argument('--disable-web-security')
  # options.add_argument('--disable-features=VizDisplayCompositor')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://localhost:4444/wd/hub',
    options: options
  )
end
