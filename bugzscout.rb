require 'rubygems'
require 'httpclient'
require 'uri'

class BugzScout
  attr_accessor :url, :user, :project, :area, :description, :new, :extra, :email, :default_message

  def initialize(url)
    self.url = url    
  end

  def submit
    body = {
      :ScoutUserName => self.user,
      :ScoutProject => self.project,
      :ScoutArea => self.area,
      :Description => self.description, 
      :ForceNewBug => self.new,
      :Extra => self.extra,
      :Email => self.email,
      :ScoutDefaultMessage => self.default_message,
      :FriendlyResponse => 0 
    }
    client = HTTPClient.new
    response = client.post(url, body).content
    if response =~ /<Error>(.*)<\/Error>/
      raise(BugzScoutError, $1)
    else
      return true
    end
  end
end

class BugzScoutError < RuntimeError ; end
  
