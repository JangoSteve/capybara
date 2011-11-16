require 'capybara'
require 'capybara/dsl'

Capybara.app = Rack::Builder.new do
  map "/" do
    if Rails.version.to_f >= 3.0
      run Rails.application  
    else # Rails 2
      use Rails::Rack::Static
      run ActionController::Dispatcher.new
    end
  end
end.to_app

Capybara.asset_root = Rails.root.join('public')
Capybara.save_and_open_page_path = Rails.root.join('tmp/capybara')

if Rails.version.to_f >= 3.1 && Rails.application.config.assets.enabled
  asset_path = File.join(Capybara.asset_root, Rails.application.config.assets.prefix)
  sprockets_environment = Rails.application.assets
  Capybara.save_and_open_page_post_process = lambda { |html|
    html.gsub!(/(#{asset_path})(.+)(['"])/, '\1' + 'hi_there' + '\3')
    html
  }
end
