# frozen_string_literal: true

class Finances::AccountForm
  include ActiveModel::Validations
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :name, :string

  attribute :url, :string
  attribute :http_method, :string

  validates :url, presence: true
  validates :http_method, presence: true

  validates :name, presence: true, length: { minimum: 5 }

  def initialize(id: nil, name:, url:, http_method:)
    super()

    self.id = id
    self.name = name
    self.url = url
    self.http_method = http_method
  end

  def persisted?
    self.id.present?
  end
end
