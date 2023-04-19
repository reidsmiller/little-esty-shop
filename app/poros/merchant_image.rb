class MerchantImage
attr_reader :image_url

  def initialize(data)
    @image_url = data[:urls][:small]
  end
end