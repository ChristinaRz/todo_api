class ApplicationController < ActionController::API
  #ελέγχει αν ο χρήστης είναι συνδεδεμένος μέσω JWT token
  def authorize_request
    # παίρνω το header Authorization: Bearer <token>
    header = request.headers['Authorization']
    
    #κραταω μόνο το token
    token = header&.split(' ')&.last

    #αποκωδικοποιηση
    decoded = JsonWebToken.decode(token)

    #χρήστης από το user_id που είναι μέσα στο token
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    #αν δεν βρέθηκε χρήστης ή το token δεν είναι έγκυρο τοτέ 401 Unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end