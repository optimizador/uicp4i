# config.ru
require './basic'
require 'rack/protection'
#require 'webrick/https'
require 'thin' 

set :protection, :except => :frame_options
#disable :protection
run Sinatra::Application
