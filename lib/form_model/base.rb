# frozen_string_literal: true

module FormModel
  class Base
    include ActiveModel::Validations
    include ActiveModel::Attributes

    attribute :url, :string
    attribute :http_method, :string

    validates :url, presence: true
    validates :http_method, presence: true

    def initialize(url:, http_method:)
      super()

      self.url = url
      self.http_method = http_method
    end

    def persisted?
      raise NotImplementedError
    end
  end
end
