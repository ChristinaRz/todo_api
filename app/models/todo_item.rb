class TodoItem < ApplicationRecord
  #κάθε item ανήκει σε ένα todo
  belongs_to :todo
  
  # περιεχόμενο υποχρεωτικό
  validates :content, presence: true
end