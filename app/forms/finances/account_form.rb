# frozen_string_literal: true

class Finances::AccountForm < ::FormModel::Base
  attribute :id, :integer
  attribute :name, :string

  validates :name,
            presence: true,
            length: { minimum: ::Account::MINIMUM_NAME_LENGTH.freeze, if: ->(f) { f.name.present? } }

  def initialize(id: nil, name:, url:, http_method:)
    super(url: url, http_method: http_method)

    self.id = id
    self.name = name
  end

  def persisted?
    self.id.present?
  end
end
