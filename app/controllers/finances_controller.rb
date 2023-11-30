# FinancesController is the parent controller for the finances section/page of the Bdgtr. So every controller under the
# Finances namespace should inherit from it.
#
# It only contains a single render method show, that serves the base view of the section to work as a SPA-like
# Turbo-based application.
class FinancesController < ApplicationController
  def show
  end
end
