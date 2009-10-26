# This library that gives you easy access to the excellent BugzScout feature of FogBugz (http://fogcreek.com/fogbugz).
# For those that don't know, BugzScout allows bug data (exceptions, user input, etc) to be reported back to your FogBugz install 
# for further diagnosis.
#
# Author:: Michael Gorsuch (mailto:michael@styledbits.com)
# Copyright:: Copyright (c) 2009 Michael Gorsuch
# License:: Distributed under the same terms as Ruby

require 'rubygems'
require 'httpclient'
require 'uri'

# This is the core class that does all of the heavy lifting.
class BugzScout
  attr_accessor :url, :user, :project, :area, :title, :new, :body, :email, :default_message

  # provide BugzScout with the URL of your FogBugz instance, including the 'scoutsubmit.asp' entry point
  # example: https://styledbits.fogbugz.com/scoutsubmit.asp
  def initialize(url)
    self.url = url
    yield self
    self.submit    
  end

  # send the response to FogBugz
  # return true if all goes well
  # throw a BugzScoutError exception along with the error text if otherwise.
  def submit
    body = {
      :ScoutUserName => self.user,
      :ScoutProject => self.project,
      :ScoutArea => self.area,
      :Description => self.title, 
      :ForceNewBug => self.new,
      :Extra => self.body,
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