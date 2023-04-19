require 'httparty'
require 'json'
require './app/services/unsplash_service'
require './app/poros/photo'

class PhotoService
  def self.service
    UnsplashService.new
  end

  def self.photo(item)
    Photo.new(service.photo(item))
  end
end