class AuthController < ApplicationController
  # POST /signup
  def signup
    #δημιουργείται νέος χρήστης με τα στοιχεία που στάλθηκαν
    user = User.new(user_params)

    if user.save
      # token για τον νέο χρήστη
      token = JsonWebToken.encode(user_id: user.id)
      render json: { id: user.id, email: user.email, token: token }, status: :created
    else
      #422 αν υπάρχει σφάλμα
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/login
  def login
    #αναζήτηση χρήστη με βάση το email
    user = User.find_by(email: params[:email])

    #ελεγχος αν υπάρχει ο χρήστης και αν το password είναι σωστό
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { id: user.id, email: user.email, token: token }
    else
      # 401 για λάθος email ή password
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # GET /auth/logout
  def logout
    # JWT :δεν υπάρχει πραγματικό logout
    # Ο client είναι υπεύθυνος να διαγράψει το token του
    render json: { message: 'Logged out successfully' }
  end

  private

  def user_params
    # μόνο email και password
    params.permit(:email, :password)
  end
end