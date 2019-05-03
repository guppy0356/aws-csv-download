Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    # If you want to run headless mode, add "args: %w[headless disable-gpu]" to chromeOptions.
    chromeOptions: {
      prefs: {
        'download.default_directory': Payment::Client::download_directory,
        'download.prompt_for_download': false
      }
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :headless_chrome
