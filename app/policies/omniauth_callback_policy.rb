OmniauthCallbackPolicy = Struct.new(:user, :omniauth_callback) do
  def facebook?
    user.nil?
  end

  def twitter?
    facebook?
  end
end
