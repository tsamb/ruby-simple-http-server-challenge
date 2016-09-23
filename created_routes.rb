require './Routes'

Routes.new '/hello', 'GET' do
	puts 'hello route'
	{
		status_code: 200,
		status_message: 'ok',
		response_body: "<h1>you hit the hello route</h1>"
	}
end

Routes.new '/goodbye', 'GET' do
	puts 'goodbye route'
	{
		status_code: 200,
		status_message: 'ok',
		response_body: "<h1>Heyyyyy goodbye :(</h1>"
	}
end
