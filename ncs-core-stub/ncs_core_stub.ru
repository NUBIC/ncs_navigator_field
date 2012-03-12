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