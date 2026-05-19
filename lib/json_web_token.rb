require 'jwt'

class JsonWebToken
  # μυστικό κλειδί για την κρυπτογράφηση του token 
  #από τις ρυθμίσεις Rails
  SECRET_KEY = Rails.application.secret_key_base

  # νέο token για τον χρήστη
  # payload: τα δεδομένα που θέλω να αποθηκεύσω
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # διαβάζει και επαληθεύει ένα token
  #αν είναι έγκυρο επιστρέφει τα δεδομένα
  #αλλιώς nil
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end