# BdgtrController is the entrypoint for Bdgtr. It only handles request to the application's root route and redirect them
# to Bdgtr's entrypoint. No controller must inherit from this controller.
#
# It only contains a action root, that simply redirects the requests from the application's root to Bdgtr's entrypoint.
class BdgtrController < ApplicationController
  def root
    redirect_to finances_path
  end
end
