class MerchantImageSearch 
  def merchant_image
      MerchantImage.new(service.merchant_images)
  end

  def service
    UnsplashService.new
  end
end
