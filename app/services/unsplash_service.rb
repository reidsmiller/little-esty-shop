class UnsplashService
  def get_logo_image
    get_url("https://api.unsplash.com/photos/DV1-0sK2--Q?client_id=CMrjMuK68BSuSMfw-mJ7RHkuQz3fmkkGeay-5NbUZSk")
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def merchant_images
    get_url("https://api.unsplash.com/photos/random?client_id=nJm3PMI0ChpgEr9xIkC_gqCPpvJF3J8mshaK517tRPI")
  end
end

