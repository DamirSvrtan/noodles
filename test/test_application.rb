require_relative 'test_helper'

class TestApp < Noodles::Application
end

class TestController < Noodles::Http::Controller

  def root_page
    "Root Page"
  end

  def index
    "hello"
  end

  def show
    render erb: 'show'
  end

  def index_with_slim
    render slim: 'index'
  end

  def index_with_haml
    render haml: 'index'
  end

  def with_response
    response("HELLOU",400)
  end

  def with_variables_erb
    @username = "Jack"
    @hello_message = "HI!"
    render erb: 'with_variables'
  end

  def with_variables_haml
    @username = "Jack"
    @hello_message = "HI!"
    render haml: 'with_variables'
  end

  def with_variables_slim
    @username = "Jack"
    @hello_message = "HI!"
    render slim: 'with_variables'
  end

  def get_rendering_path(view_name, template_name)
    File.join 'test', 'views', "#{view_name}.#{template_name}"
  end
end

class NoodlesTestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    app = TestApp.new
    app.http_app.routes do
      root_to "test#root_page"
      get "test/index", "test#index"
      get "test/show", "test#show"
      get "test/index_with_slim", "test#index_with_slim"
      get "test/index_with_haml", "test#index_with_haml"
      get "pipa/:id/slavina/:slavina_id", "test#hamly"
      get "/test/with_response", "test#with_response"
      get "sub-app", proc { |env| [200, {}, [env['PATH_INFO']]] }
      get "sub-app2", proc { [200, {}, ['ANOTHER SUB APP']] }
      get "with_variables_erb", "test#with_variables_erb"
      get "with_variables_haml", "test#with_variables_haml"
      get "with_variables_slim", "test#with_variables_slim"
    end
    app
  end

  def test_root_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Root Page"]
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

  def xtest_with_response
    get "/test/with_response"

    assert last_response.bad_request?
    assert last_response.body["HELLOU"]
  end

  def test_sub_app
    get "/sub-app"

    assert last_response.ok?
    body = last_response.body
    assert body["sub-app"]
  end

  def test_sub_app2
    get "/sub-app2"

    assert last_response.ok?
    body = last_response.body
    assert body["ANOTHER SUB APP"]
  end

  def test_bad_request
    get "/something-bad"
    assert last_response.bad_request?
  end

  def test_with_variables_erb
    get 'with_variables_erb'

    assert last_response.ok?
    body = last_response.body
    assert body["Jack"]
    assert body["HI!"]
  end

  def test_with_variables_haml
    get 'with_variables_haml'

    assert last_response.ok?
    body = last_response.body
    binding.pry
    assert body["Jack"]
    assert body["HI!"]
  end

  def test_with_variables_erb
    get 'with_variables_slim'

    assert last_response.ok?
    body = last_response.body
    assert body["Jack"]
    assert body["HI!"]
  end
  def test_environment
    assert !Noodles.production?
    assert !Noodles.test?
    assert Noodles.development?
    ENV['RACK_ENV'] = "production"
    assert Noodles.production?
    assert !Noodles.development?
  end
end