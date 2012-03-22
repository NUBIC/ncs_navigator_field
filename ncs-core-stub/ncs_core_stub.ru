require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
class NCSCoreStub < Sinatra::Base
  post '/api/v1/fieldwork' do
    env['aker.check'].authentication_required!
    username = env['aker.check'].user.username
    if username
      missing = [:start_date, :end_date, :client_id].select{|v| params[v].blank?}
      if missing.empty?
        headers 'location' => 'http://localhost:4567/api/v1/fieldwork/92c37ba9-7297-4763-9c7f-80ac6ad16727'
        content_type :json
        IO.read("contacts.json")
      else
        status 400
        "Missing parameters #{missing.join(', ')}"
      end
    else    
      403
    end
  end

  put '/api/v1/fieldwork/:identifier' do
    env['aker.check'].authentication_required!
    username = env['aker.check'].user.username
    if username
      puts "request.body: #{request.body.gets.inspect}"
      status 202
      content_type :json
      request.body.rewind
    end
  end

end

require 'aker'
Aker.configure do
  authorities :cas
  ui_mode :cas
  api_mode :cas_proxy
  central '/etc/nubic/bcsec-local.yml'
end

use Rack::Session::Cookie

Aker::Rack.use_in(self)

run NCSCoreStub