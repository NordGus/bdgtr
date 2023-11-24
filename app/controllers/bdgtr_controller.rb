class BdgtrController < ActionController::Base
  def root
    redirect_to finances_path
  end
end
