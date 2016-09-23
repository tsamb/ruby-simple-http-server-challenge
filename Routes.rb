class Routes
	attr_accessor :path, :http_method, :function

	def initialize(path, http_method, &block)
		@path = path
		@http_method = http_method
		@function = block

	end

	def respond
		route_response = function.call
		status_code = (defined?(route_response[:status_code])).nil? ? 200 : route_response[:status_code]
		status_message = (defined?(route_response[:status_message])).nil? ? 'ok' : route_response[:status_message]
		response_body = (defined?(route_response[:response_body])).nil? ? nil : route_response[:response_body]

		response = ["HTTP/1.1 #{status_code} #{status_message}", "content-type: text/html; charset=iso-8859-1"]

		if(!(defined?(response_body)).nil?)
			response += ["Content-Length: #{response_body.length}", "\r\n", response_body]
		end

		response
	end
end
