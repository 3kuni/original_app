require 'spec_helper'

describe Studysession do
  pending "add some examples to (or delete) #{__FILE__}"
	
	describe "Stats" do

		it "should have the content 'Sample App'" do
		  visit '/static_pages/home'
		  expect(page).to have_content('Sample App')
		end
	end
end
