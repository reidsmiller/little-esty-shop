class LogoImage
  attr_reader :image_url, :image_likes

  def initialize(data)
    @image_url = data[:urls][:thumb]
    @image_likes = data[:likes]
  end
end