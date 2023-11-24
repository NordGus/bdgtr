module Command
  class Base
    include ActiveModel::Validations
    include ActiveModel::Attributes

    def execute
      raise NotImplementedError
    end

    def valid?
      return Railway::Response.success(self) if super
      Railway::Response.failure(self, self.errors.messages)
    end

    protected

    class ScopeContainer
      attr_accessor :scope

      def initialize(scope)
        self.scope = scope
      end
    end
  end
end