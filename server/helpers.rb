module Helpers
  def token_verification
    secret = raspberry.serial + request.path
    valid_token = BCrypt::Engine.hash_secret(secret, settings.salt)
    halt 403 unless valid_token == request.env['HTTP_TOKEN']
  end

  def rpi_activation
    raspberry.activate
    resp_body(serial: raspberry.serial, revision: raspberry.revision)
  end

  def resp_body(message)
    message.to_json
  end

  def raspberry
    Raspberry.first
  end
end
