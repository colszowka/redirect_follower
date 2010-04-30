require 'net/http'

#
# Shorthand for RedirectFollower.new(url).resolve.url - just get the
# destination url for given url
#
def RedirectFollower(url, limit=5)
  RedirectFollower.new(url, limit).url
end

#
# Follow redirects for given urls with net http to find out their destinations
#
# Source code mostly ripped from John Nunemaker:
# http://railstips.org/blog/archives/2009/03/04/following-redirects-with-nethttp/
#
class RedirectFollower
  class TooManyRedirects < StandardError; end
  
  attr_accessor :original_url, :redirect_limit
  attr_writer :url, :response
  
  def initialize(original_url, limit=5)
    @original_url, @redirect_limit = original_url, limit
  end
  
  def url
    resolve unless @url
    @url
  end
  
  def body
    response.body
  end
  
  def response
    resolve unless @response
    @response
  end
  
  private
  
    def resolve
      raise TooManyRedirects if redirect_limit < 0
      
      # Set up current url if not resolved yet
      self.url = original_url unless @url
      
      self.response = Net::HTTP.get_response(URI.parse(url))

      if response.kind_of?(Net::HTTPRedirection)
        self.url = redirect_url
        self.redirect_limit -= 1
        resolve
      end
      
      self
    end

    def redirect_url
      if response['location'].nil?
        response.body.match(/<a href=\"([^>]+)\">/i)[1]
      else
        response['location']
      end
    end
end
