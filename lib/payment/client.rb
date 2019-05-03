require "capybara"
require "capybara/dsl"
require "selenium-webdriver"
require "listen"
require "payment/client/browser"
require "payment/client/version"

module Payment
  class Client
    include Capybara::DSL

    def self.download_directory
      @@download_directory
    end

    def self.download_directory=(download_directory)
      @@download_directory = download_directory
    end

    def initialize(email, password)
      @email = email
      @password = password
      @downloaded = false

      listener = Listen.to(Client::download_directory, only: /\.csv$/) do |modified, added, removed|
        @downloaded = true if added.size > 0
      end

      listener.start
    end

    def download
      visit "https://console.aws.amazon.com/billing/home?nc2=h_m_bc"

      page.find("#resolving_input").set(@email)
      page.find("#next_button").click

      page.find("#ap_password", wait: 10.0).set(@password)
      page.find("#signInSubmit-input").click

      visit "https://console.aws.amazon.com/billing/home?nc2=h_m_bc#/paymenthistory"

      page.find("i.icon-download-alt", wait: 10.0).click

      wait_for_download
    ensure
      page.driver.quit
    end

    private

      def wait_for_download
        sleep 0.5 until @downloaded
      end
  end
end

require "payment/client/railtie" if defined?(Rails)
