require './config/application'
require './config/router'
require 'better_errors'

use Rack::Session::Cookie, :secret => 'abc123'
use BetterErrors::Middleware if Noodles.env.development?
use Rack::CommonLogger, $stdout
use Rack::ContentType
use Rack::MethodOverride
use Rack::Static, urls: ["/css", "/images", "/js", "/favicon.ico"], root: "public"

run Noodles.application