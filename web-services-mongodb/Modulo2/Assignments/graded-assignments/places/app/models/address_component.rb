class AddressComponent
  attr_reader :long_name, :short_name, :types

# Can set the attributes from a has with keys
  def initialize(params)
    @long_name = params[:long_name]
    @short_name = params[:short_name]
    @types = params[:types]
  end

end
