require 'rubygems'
require 'httpclient'
require 'uri'

class BugzScout
  attr_accessor :url, :user, :project, :area, :description, :new, :extra, :email, :default_message

  # provide BugzScout with the URL of your FogBugz instance, including the 'scoutsubmit.asp' entry point
  # example: https://styledbits.fogbugz.com/scoutsubmit.asp
  def initialize(url)
    self.url = url    
  end

  # send the response to FogBugz
  # return true if all goes well
  # throw a BugzScoutError exception along with the error text if otherwise.
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
      # if we see an error response, we know that we fudged some of our input values to BugzScout
      # the error message should contain where we went wrong.
      # We raise the exception so the user can catch it and log if necessary.  No one likes things that fail silently!
      raise(BugzScoutError, $1)
    else
      # we'll return 'true' for the sake of clarity
      return true
    end
    
  end
end

# just a simple custom exception
class BugzScoutError < RuntimeError ; end
  
