class Point
  attr_accessor :longitude, :latitude

  # Set the attributes from a hash with keys lat an lng from GeoJSON Point format
  def initialize(params)
    if params[:type]
      @longitude = params[:coordinates][0]
      @latitude = params[:coordinates][1]
    else
      @longitude = params[:lng]
      @latitude = params[:lat]
    end
  end

  # produces a GeoJSON Point hash
  def to_hash
    {:type=>"Point",:coordinates=>[@longitude, @latitude]} #GeoJSON Point format
  end

end
