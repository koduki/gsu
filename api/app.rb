require 'sinatra'
require 'json'
require './lib/gadmin_api.rb'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || '8080'

post '/jit/:user_name/:group_name/:expire' do |u, g, sec|
    content_type :json

    admin = GCPAdminAPI.new
    r = admin.attach_group("#{u}@#{ENV['GCP_DOMAIN']}", "#{g}@#{ENV['GCP_DOMAIN']}")
    admin.set_expire(sec)
    
    r.to_json
end

post '/attach/:user_name/:group_name' do |u, g|
    content_type :json

    r = GCPAdminAPI.new.attach_group("#{u}@#{ENV['GCP_DOMAIN']}", "#{g}@#{ENV['GCP_DOMAIN']}")
    r.to_json
end

post '/detach/:user_name/:group_name' do |u, g|
    content_type :json

    r = GCPAdminAPI.new.detach_group("#{u}@#{ENV['GCP_DOMAIN']}", "#{g}@#{ENV['GCP_DOMAIN']}")
    r.to_json
end

get '/groups' do 
    content_type :json

    r = GCPAdminAPI.new.list_groups_all
    r.to_json
end

get '/groups/:user_name' do |u|
    content_type :json

    r = GCPAdminAPI.new.list_groups("#{u}@#{ENV['GCP_DOMAIN']}")
    r.to_json
end

get '/healthcheck' do 
    content_type :json

    GCPAdminAPI.new.healthcheck
    {"status"=> "ok"}.to_json
end