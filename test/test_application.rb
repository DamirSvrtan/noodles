require_relative 'test_helper'

class TestApp < Noodles::Application
end

class NoodlesTestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end


end