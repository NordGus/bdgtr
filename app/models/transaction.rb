class Transaction < ApplicationRecord
  belongs_to :from, class_name: "Account"
  belongs_to :to, class_name: "Account"

  validates :from_id, presence: true
  validates :to_id, comparison: { other_than: :from_id }
  validates :amount, comparison: { greater_than: 0 }
  validates :issued_at, presence: true
  validates :executed_at, comparison: { greater_than_or_equal_to: :issued_at }, if: ->(t) { t.executed_at.present? }
end
