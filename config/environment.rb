# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Langapp::Application.initialize!

# Counter used for incrementing articles
ARTICLE_INDEX = 0
