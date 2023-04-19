class Photo
  attr_reader :data, :url

  def initialize(data)
    @data = data
    @url = data[:urls][:small]
  end
end