class Todo < ApplicationRecord
  # κάθε todo ανήκει σε έναν χρήστη
  belongs_to :user
  
  # ένα todo έχει πολλά items 
  has_many :todo_items, dependent: :destroy
  
  #τίτλος υποχρεωτικός
  validates :title, presence: true
end