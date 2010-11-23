require 'rubygems'
require 'sinatra'
require 'json'

get '/' do
	'Deploy Server is running'
end

get %r{/deploy/([\w\.]+)} do |name|
	deploy(name)
end

post %r{/deploy/([\w\.]+)} do |name|
	deploy(name)
end

def deploy(name)
	script = File.dirname(File.expand_path(__FILE__))+"/scripts/deploy_#{name}"
	return [400,'Missing Deploy Script'] if not File.exist?(script)
	return [400,'Invalid Deploy Script'] if not File.executable?(script)
	
	begin # Parse GitHub Payload
	  push = JSON.parse(params[:payload])
	  puts "Running #{script}"
	  puts "  Reference #{push['ref']}"
	  puts "  Hash #{push['after']}"
	  result = system("#{script} #{push['ref']} #{push['after']}")
	  puts result
	rescue
	  puts "Running #{script}"
	  result = system(script)
	  puts result
  end
	result
end

not_found do
	'This is nowhere to be found.'
end

