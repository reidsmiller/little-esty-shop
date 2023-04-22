class UnsplashService
  def get_logo_image
    get_url("https://api.unsplash.com/photos/t9jQie6cUhg?client_id=CMrjMuK68BSuSMfw-mJ7RHkuQz3fmkkGeay-5NbUZSk")
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def merchant_images
    get_url("https://api.unsplash.com/photos/random?client_id=CMrjMuK68BSuSMfw-mJ7RHkuQz3fmkkGeay-5NbUZSk")
  end

  def photo(item)
    get_url("https://api.unsplash.com/photos/random?client_id=CMrjMuK68BSuSMfw-mJ7RHkuQz3fmkkGeay-5NbUZSk&query=#{item}")
  end
end
