require_relative 'test_helper'

class TestApp < Noodles::Application
end

class TestController < Noodles::Http::Controller
  def index
    "hello"
  end

  def show
    render erb: 'show'
  end

  def with_response
    response("HELLOU",400)
  end

  def index_with_slim
    render slim: 'index'
  end

  def index_with_haml
    render haml: 'index'
  end

  def get_rendering_path(view_name, template_name)
    File.join 'test', 'views', "#{view_name}.#{template_name}"
  end
end

class NoodlesTestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_root_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_index_request
    get "/test/index"

    assert last_response.ok?
    assert last_response.body["hello"]
  end

  def test_show_request
    get "/test/show"

    assert last_response.ok?
    assert last_response.body["<h1>Show</h1>"]
  end

  def test_index_with_slim
    get "/test/index_with_slim"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
    assert body["Hello Twice"]
  end

  def test_index_with_haml
    get "/test/index_with_haml"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
    assert body["Hello Twice"]
  end

  def test_with_response
    get "/test/with_response"

    assert last_response.bad_request?
    assert last_response.body["HELLOU"]
  end
end