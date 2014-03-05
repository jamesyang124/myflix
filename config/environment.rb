# Load the rails application
require File.expand_path('../application', __FILE__)

use Rack::Deflater

# Initialize the rails application
Myflix::Application.initialize!
