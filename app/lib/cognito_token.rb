require 'net/http'

class CognitoToken
  attr_reader :realm
  attr_reader :config

  def initialize(realm)
    @realm = realm
    @config = Rails.configuration.cognito[@realm]
    @user_pool_id = @config['user_pool_id']
    @region = @config['region']
  end

  def decode(token, retry_count = 1)
    jwt = JWT.decode(token, nil, false)
    raise 'Unauthorized' if JWTBlacklist.where(jti: jwt.first['jti']).exists?
    raise 'Invalid JWT' unless key = get_key_for(jwt.last['kid'])

    rsa_key = JSON::JWK.new(key).to_key
    JWT.decode(token, rsa_key, true, algorithm: key['alg'])
  rescue JWT::VerificationError => e
    raise e if retry_count == 0
    refresh_keys

    decode(token, retry_count - 1)
  end

  def cognito_user
    @cognito_user ||= CognitoUser.new(@realm)
  end

  private

  def get_key_for(kid)
    key = Value::active.where(key: kid).first
    return JSON.parse(key.value) if key

    keys = refresh_keys
    keys[kid]
  end

  def get_keys_from_web
    uri = URI.parse("https://cognito-idp.#{@region}.amazonaws.com/#{@user_pool_id}/.well-known/jwks.json")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    result = http.get(uri.request_uri)
    throw 'Failed to get keys' unless result

    JSON.parse(result.body)['keys'].reduce({}) do |h, key|
      h[key['kid']] = key

      h
    end
  end

  def refresh_keys
    keys = get_keys_from_web
    Value.where(key: keys.keys).destroy_all
    values = []
    expire_at = DateTime.now + 1.week

    keys.each do |k, v|
      values.push([k, v.to_json, expire_at])
    end
    Value.import([:key, :value, :expire_at], values)
    keys
  end
end
