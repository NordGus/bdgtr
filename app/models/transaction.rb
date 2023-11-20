class Transaction < ApplicationRecord
  belongs_to :from, class_name: "Account"
  belongs_to :to, class_name: "Account"

  validates_comparison_of :from_id, other_than: :to_id
  validates_comparison_of :to_id, other_than: :from_id
  validates_presence_of :amount
  validates_comparison_of :amount, greater_than: 0
end
