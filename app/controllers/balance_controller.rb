# BalanceController is the parent controller for the balance section/page of the Bdgtr. So every controller under the
# Balance namespace should inherit from it.
#
# It only contains a single render method applet, that serves the base view of the section to work as a SPA-like
# Turbo-based application.
class BalanceController < BdgtrController
  def applet
  end
end
