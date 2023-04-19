class LogoImage
  attr_reader :image_url

  def initialize(data)
    @image_url = data[:urls][:thumb]
  end
end