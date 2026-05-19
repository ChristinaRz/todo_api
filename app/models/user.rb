class User < ApplicationRecord
  # κρυπτογράφηση password με bcrypt
  has_secure_password
  
  # ένας χρήστης έχει πολλά todos (αν διαγραφεί ο χρήστης, διαγράφονται και τα todos)
  has_many :todos, dependent: :destroy
  
  #  email υποχρεωτικό και μοναδικό
  validates :email, presence: true, uniqueness: true
end