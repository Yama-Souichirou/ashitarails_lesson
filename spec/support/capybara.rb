require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 15

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless') # ヘッドレスモードをonにするオプション
  options.add_argument('--disable-gpu') # 暫定的に必要なフラグとのこと
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
