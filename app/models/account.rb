class Account < ApplicationRecord
  has_many :outgoing_transactions, class_name: "Transaction", foreign_key: :from_id, dependent: :destroy
  has_many :incoming_transactions, class_name: "Transaction", foreign_key: :to_id, dependent: :destroy

  validates_presence_of :name
  validates_length_of :name, minimum: 5
end
