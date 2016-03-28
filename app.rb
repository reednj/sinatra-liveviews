
require 'sinatra'

if development?
	require 'bundler'
	require 'sinatra/reloader'
	Bundler.require
end

require 'sinatra/liveviews'
require './lib/model'

configure :development do
	also_reload './lib/model.rb'
end

get '/' do
	redirect to('/admin/stats')
end

get '/admin/stats' do
	erb :home
end

live '/admin/stats' do |document|

	document.on_load do
		document.element('#js-count').text = 'ready'
	end

	UserScore.where(:user_id => 1).on_count_change do |scores|
		document.element('#js-count').text = "#{scores.count} records"
		document.element('#js-sum').text = "total: #{scores.sum(:score).round}"
		document.element('#js-avg').text = "avg: #{scores.avg(:score).round(2)}"
	end
end
