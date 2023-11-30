class Account < ApplicationRecord
  MINIMUM_NAME_LENGTH = 5.freeze

  has_many :outgoing_transactions, class_name: "Transaction", foreign_key: :from_id, dependent: :destroy
  has_many :incoming_transactions, class_name: "Transaction", foreign_key: :to_id, dependent: :destroy

  validates :name, presence: true, length: { minimum: MINIMUM_NAME_LENGTH }
end
