class LogoImageSearch
  def logo_image
    LogoImage.new(service.get_logo_image)
  end

  def service
    UnsplashService.new
  end
end