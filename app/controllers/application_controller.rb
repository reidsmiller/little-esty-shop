class ApplicationController < ActionController::Base
  helper_method :get_logo
  helper_method :get_logo_likes


  def get_logo
   @logo = LogoImageSearch.new.logo_image.image_url
  end

  def get_logo_likes
   @logo_likes = LogoImageSearch.new.logo_image.image_likes 
  end
end
