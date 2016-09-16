# Simple Ruby HTTP Client/Server

The goal here is to take Ruby's standard library TCP Socket classes and with them build a simple HTTP server and client.

At the end of this challenge, you should have be able to run `server.rb`, have it listen on a given port, connect to that port from your browser and have your server return a message the browser can understand. Wink wink, nudge nudge: an HTTP response. What's the browser going to send in the first place? Yup, an HTTP request. So read up on those things (useful link below).

The server is the most important piece here. It should be able to respond to different routes, e.g. sending a request to `http://localhost:2000/` might display "Welcome to the home page" on the browser, whereas connecting to `http://localhost:2000/contact` might display "You can contact me at the following address...". Ultimately, you are aiming to create a simplified version of [Rack](https://rack.github.io/) or even [Sinatra](http://www.sinatrarb.com/) (which uses Rack under the hood — just like Rails!).

Bonus points for:

1. Creating a client that acts similarly to the unix utility `curl`. That is, you could run `ruby client.rb http://localhost:2000/contact` and "You can contact me at the following address.." would print in your terminal via STDOUT (or whatever the body of the response is...)
2. Refactoring your code so that it follows OO best practices and would make Sandi Metz proud.
3. [Shebanging](https://stackoverflow.com/questions/17447532/what-is-the-use-of-usr-local-bin-ruby-w-at-the-start-of-a-ruby-program) your client and adding it to your path so you can simply type `client http://www.example.com` and your client script will run
4. Creating a DSL in your server akin to Sinatra's routes. That is, you can define GET requests via a method that takes a string as an argument and a block. Something like:
```ruby
get '/contact' do
  "You can contact me at the following address..." 
end

get '/home' do
  "Hey, you found home." 
end
```

Useful resources:

http://ruby-doc.org/stdlib-2.3.0/libdoc/socket/rdoc/Socket.html
https://www.ntu.edu.sg/home/ehchua/programming/webprogramming/HTTP_Basics.html
