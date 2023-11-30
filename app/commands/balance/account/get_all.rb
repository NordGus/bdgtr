# frozen_string_literal: true

# Balance::Account::GetAll contains to retrieve all accounts in the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Balance::Account::GetAll < Command::Base
  def initialize
    super
  end

  def execute
    valid?
      .and_then { build_scope }
  end

  private

  def build_scope
    scope = Account.order(name: :desc)

    Railway::Response.success(ScopeContainer.new(scope))
  end
end
