# wait for blank line
# validate host
# while loop over this until you get a blank line


# Verbatim code example from:
# http://ruby-doc.org/stdlib-2.3.0/libdoc/socket/rdoc/Socket.html
require 'pry'
require 'socket'
require './created_routes'
require 'json'

SERVER_ADDRESS = 'localhost:2000'

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

def is_host_valid?(req)
	# ensures that the request included a host, and the host matches the specified name.
	req_host = nil
	req.each do | req_part |
		if(req_part.downcase.include? 'host')
			req_host = req_part.split(' ')
			req_host.shift
			req_host = req_host.join(' ')
		end
	end
	!req_host.nil? && req_host == SERVER_ADDRESS
end

def get_req_info(req)
	#parses the http method (GET, POST, etc.), the path, and the http version and returns a hash 
	req_info = {}
	http_req = req.slice(0).split(' ')
	req_info[:type] = http_req[0]
	req_info[:path] = http_req[1]
	req_info[:http_version] = http_req[2]

	if(req_info[:path][req_info[:path].length-1] == '/')
		req_info[:path].slice!(req_info[:path].length-1)
	end
	req_info
end

def find_and_execute_route(routes, req)
	req_info = get_req_info(req)

	response = nil
	routes.each do |route| 
		# loop over each route and check if its path matches the request path and 
		# if its method matches the request's method
		if (route.path == req_info[:path] && route.http_method.downcase == req_info[:type].downcase)
			body = nil
			if ((req_info[:type] == 'POST' || req_info[:type] == 'PUT') && req[req.length-2] == '') 
				# if it's a post/put, and the second to last elem is a blank string 
				# (indicating that theres a body on the next line)
				begin
					body = JSON.parse(req[req.length-1])
				rescue => e
					# handles invalid, non-json bodies
					return create_reject_response('400', 'invalid_body', "Body is invalid: #{e}")
				end
			end
			response = route.respond(body)
		end
	end
	if(response.empty?)
		response = create_reject_response('404', 'not_found', 'We couldn\'t find that route!')
	end
	response
end

def create_response(req, routes)
	if !is_host_valid?(req)
		return create_reject_response('400', 'host_not_specified', 'You did not specify in a valid host.')
	end

	find_and_execute_route(routes, req)
end

loop do

  client = server.accept    # Wait for a client to connect

	request = client.recv(1024).split("\r\n") # receive request and split by new lines

	formatted_response = create_response(request, routes)
 	formatted_response.each do | response_line | # write each line of the response body to the client
 		client.puts response_line
 	end
 	client.close
end
