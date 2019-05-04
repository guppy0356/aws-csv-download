require 'rails/railtie'

module Payment
  class Railtie < Rails::Railtie
    config.payment_client = ActiveSupport::OrderedOptions.new

    config.after_initialize do |app|
      Payment::Client::download_directory = app.config.payment_client.download_directory
    end
  end
end
