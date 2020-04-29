class JwtHelper
  # Encode and Decode JWT based on current application request

  def initialize(application)
    @algorithm = 'HS256'
    @application = application
  end

  def encode(payload)
    JWT.encode(payload, consumer_secret, @algorithm)
  end

  def decode(token)
    decoded = JWT.decode(token, consumer_secret, @algorithm).first
    if decoded.is_a? Array
      decoded.map(&:symbolize_keys)
    else
      decoded.symbolize_keys
    end
  end

  def check(token)
    JWT.decode(token, consumer_secret, @algorithm).first
  end

  def consumer_secret
    Consumers::Secret.new(@application).call
  end
end
