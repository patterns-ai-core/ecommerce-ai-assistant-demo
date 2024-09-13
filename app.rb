require_relative "./main.rb"

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }

  use MainController

  get '/' do
    erb :index
  end
end
