SearchPolicy = Struct.new(:user, :search) do
  def search?
    true
  end
end
