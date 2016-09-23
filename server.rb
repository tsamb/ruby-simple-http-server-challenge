# wait for blank line
# validate host
# while loop over this until you get a blank line


# Verbatim code example from:
# http://ruby-doc.org/stdlib-2.3.0/libdoc/socket/rdoc/Socket.html
require 'pry'
require 'socket'
require './created_routes'

server = TCPServer.new 2000 # Server bound to port 2000

routes = []
ObjectSpace.each_object(Routes) do |routeObj|
	routes.push(routeObj)
end

def create_reject_response(status_code = 400, status_message = 'invalid_request', error_message = "Something went wrong!")
	response = ["http/1.1 #{status_code} #{status_message}", "content-type: text/html; charset=iso-8859-1"]
	response_body = "<h1>#{error_message}</h1>"
	response.push("Content-Length: #{response_body.length}")
	response.push("\r\n")
	response.push(response_body)

	response
end

def create_response(req, routes)
	req.map! do |req_part|
		req_part.strip!
	end
	http_req = req.slice(0).split(' ')


	req_type = http_req[0]
	req_path = http_req[1]
	req_http_version = http_req[2]

	if(req_path[req_path.length-1] == '/')
		req_path.slice!(req_path.length-1)
	end

	response = []
	routes.each do |route|
		if (route.path == req_path && route.http_method.downcase == req_type.downcase)
			response = route.respond
		end
	end
	if(response.empty?)
		response = create_reject_response('404', 'not_found', 'We couldn\'t find that route!')
	end

	response
end

loop do

  client = server.accept    # Wait for a client to connect
	# parse the http request to get the type, the path, and the http version
	req = []
	req_line = client.gets
	while req_line != "\r\n"
	  req.push(req_line)
		req_line = client.gets
	end
	formatted_response = create_response(req, routes)

 	formatted_response.each do | response_line |
 		client.puts response_line
 	end
 	client.close
end
