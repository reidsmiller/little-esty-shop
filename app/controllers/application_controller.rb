class ApplicationController < ActionController::Base
  helper_method :get_logo

  def get_logo
   @logo = LogoImageSearch.new.logo_image.image_url
  end
end
