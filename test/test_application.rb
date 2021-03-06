require_relative 'test_helper'

class TestApp < Noodles::Application
end

module NoodleCurrent
  def current_user
    "Damir"
  end
end

class NoodleView
  include NoodleCurrent
end

class TestController < Noodles::Http::Controller
  view NoodleView

  def root_page
    text "Root Page"
  end

  def index
    text "hello"
  end

  def show
    erb 'show'
  end

  def index_with_slim
    slim 'index'
  end

  def index_with_haml
    haml 'index'
  end

  def with_current_user
    erb 'current_user_temp'
  end

  def with_current_user_haml
    haml 'current_user_temp'
  end  

  def with_current_user_slim
    slim 'current_user_temp'
  end  

  def with_variables_erb
    @username = "Jack"
    @hello_message = "HI!"
    erb 'with_variables'
  end

  def with_variables_haml
    @username = "Jack"
    @hello_message = "HI!"
    haml 'with_variables'
  end

  def with_variables_slim
    @username = "Jack"
    @hello_message = "HI!"
    slim 'with_variables'
  end

  def change_response_status_code
    response.status = 201
    haml 'index'
  end

  def post_request
    haml 'index'
  end

  def cookie_setting
    response.set_cookie "user_id", 1
    haml 'index'
  end

  def cookie_deletion
    response.delete_cookie 'user_id'
    haml 'index'
  end

  def redirecting_path
    redirect 'test/index'
  end

  def json_response
    json({ username: "Jack", sex: "M" })
  end

  private

    def get_rendering_path(view_name, template_name)
      File.join 'test', 'templates', "#{view_name}.#{template_name}"
    end
end

class NoodlesTestApp < Minitest::Test
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
      get "sub-app", proc { |env| [200, {}, [env['PATH_INFO']]] }
      get "sub-app2", proc { [200, {}, ['ANOTHER SUB APP']] }
      get "with_variables_erb", "test#with_variables_erb"
      get "with_variables_haml", "test#with_variables_haml"
      get "with_variables_slim", "test#with_variables_slim"
      get "change_response_status_code", "test#change_response_status_code"
      get "cookie_setting", "test#cookie_setting"
      get "cookie_deletion", "test#cookie_deletion"
      post "testing_post", "test#post_request"
      get "redirecting_path", "test#redirecting_path"
      get 'with_current_user', "test#with_current_user"
      get 'with_current_user_slim', "test#with_current_user_slim"
      get 'with_current_user_haml', "test#with_current_user_haml"
      get 'json_response', 'test#json_response'
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
    assert last_response.status == 404
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
    assert body["Jack"]
    assert body["HI!"]
  end

  def test_with_variables_slim
    get 'with_variables_slim'

    assert last_response.ok?
    body = last_response.body

    assert body["Jack"]
    assert body["HI!"]
  end


  def test_change_response_status_code
    get 'change_response_status_code'

    assert last_response.status == 201
  end

  def test_post_request
    post 'testing_post'

    assert last_response.ok?
  end

  def test_getting_a_post_request_should_return_bad_request
    get 'testing_post'

    assert last_response.status == 404
  end

  def test_cookie_setting
    get 'cookie_setting'
    assert last_response.headers['Set-Cookie'] == 'user_id=1'
  end

  def test_cookie_deletion
    get 'cookie_deletion'
    assert last_response.headers['Set-Cookie'] =~ /user_id=; max-age=0;/
  end

  def test_redirecting_path
    get 'redirecting_path'
    assert last_response.status == 302
    assert last_response['Location'] == "test/index"
  end

  def test_with_current_user
    get 'with_current_user'
    assert last_response.ok?
    assert last_response.body['Damir']
  end

  def test_with_current_user_slim
    get 'with_current_user_slim'
    assert last_response.ok?
    assert last_response.body['Damir']
  end

  def test_with_current_user_haml
    get 'with_current_user_haml'
    assert last_response.ok?
    assert last_response.body['Damir']
  end

  def test_json_response
    get 'json_response'
    assert last_response.ok?
    body = last_response.body
    body_hash = JSON.parse(body)
    assert_equal "Jack", body_hash['username']
    assert_equal "M", body_hash['sex']
  end

end


class NoRouterTestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    app = TestApp.new
  end

  def test_no_routes
    assert_raises Noodles::Http::NoRouterError do
      get '/'
    end
  end
end