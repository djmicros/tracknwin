class RidesController < ApplicationController

	def new
	#require "cgi"
	#cgi_request = CGI::new()

	@debug = params[:title]
	#@debug = CGI::parse(request.query_string).to_json
	#@debug = cgi_request.query_string
	# cgi_request.params['hello']
	end
	
	
end
