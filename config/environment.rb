# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
#AmazonTest::Application.initialize!
 
Amazon::Ecs.options = { #api key .
    :associate_tag => 'stardy-22',
    :AWS_access_key_id => 'AKIAIL47C47MTYLX7HKA',
    :AWS_secret_key => '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', 
}