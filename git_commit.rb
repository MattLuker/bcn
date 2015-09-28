#!/usr/bin/env ruby
#
# Use Shoes dialog to get git commit message, then commit and push repo.
#

require 'sinatra'
require 'sinatra/reloader'
require 'launchy'

enable :sessions

get '/' do
  html = <<FORM
  <br/><br/>
  <div style="margin: 0 auto; max-width: 700px;">
    <h4>Enter a Commit Message:</h4>
    <form action="/commit" method="post">
      <textarea name="message" cols="50" rows="10"></textarea>
      <br/><br/>
      <input type="submit"/>
    </form>
  </div>
FORM
end

post '/commit' do
  puts params[:message]

  session[:add] = `git add .`
  session[:commit] = `git commit -am "#{params[:message]}"`
  session[:push] = `git push`
  redirect to('/results')
end

get '/results' do
  html = <<HTML
  <br/><br/>
  <div style="margin: 0 auto; max-width: 700px;">
    <h4>Results:</h4>

    <strong>Add:</strong> #{session[:add]}
    <br/><br/>
    <strong>Commit:</strong> #{session[:commit]}
    <br/><br/>
    <strong>Push:</strong> #{session[:push]}
    <br/><br/>
    <a href="/">Back</a>
  </div>
HTML
end

Launchy.open("http://localhost:4567")
