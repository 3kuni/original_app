require 'spec_helper'

describe StudysessionController do

  describe "GET 'hello'" do
    it "returns http success" do
      get 'hello'
      response.should be_success
    end
  end

end
