require './Routes'

Routes.new '/hello', 'GET' do
  {
    status_code: 200,
    status_message: 'ok',
    response_body: "<h1>you hit the hello route</h1>"
  }
end

Routes.new '/goodbye', 'GET' do
  {
    status_code: 200,
    status_message: 'ok',
    response_body: "<h1>Heyyyyy goodbye :(</h1>"
  }
end

Routes.new '/goodbye', 'POST' do |body|
  response = nil
  if body.nil?
    response = {
      status_code: 400,
      status_message: 'no_body_sent',
      response_body: "<h1>You did not send a body!</h1>"
    }
  elsif body["name"].nil?
    response = {
      status_code: 400,
      status_message: 'no_name_specified',
      response_body: "<h1>You did not specify a name!</h1>"
    }
  else
    person_name = body["name"]
    response = {
      status_code: 200,
      status_message: 'ok',
      response_body: "<h1>hello, #{person_name}</h1>"
    }
  end
  response
end
