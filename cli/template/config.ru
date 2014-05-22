require './config/application'
require './config/router'

use Rack::Session::Cookie, :secret => 'abc123'
use Rack::ShowExceptions if Noodles.env.development?
use Rack::CommonLogger, $stdout
use Rack::ContentType
use Rack::Static, urls: ["/css", "/images", "/js", "/favicon.ico"], root: "public"

run Noodles.application