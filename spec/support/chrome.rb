# spec/support/chrome.rb

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome do |driver_options|
      driver_options.add_argument('--headless')
      driver_options.add_argument('--disable-gpu')
      driver_options.add_argument('--no-sandbox')
      driver_options.add_argument('--disable-dev-shm-usage')
      driver_options.add_argument('--window-size=1400,1400')
    end
  end
end
