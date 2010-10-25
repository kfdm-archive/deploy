require 'rubygems'
require 'sinatra'

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
	result = system(script)
	result
end

not_found do
	'This is nowhere to be found.'
end

