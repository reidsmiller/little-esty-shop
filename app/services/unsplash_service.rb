class UnsplashService
  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def photo(item)
    get_url("https://api.unsplash.com/photos/random?client_id=GFgfSzqSWLE9wIIgZXasjLpoY5FFbWbbOir28ZaAaOQ&query=#{item}")
  end
end