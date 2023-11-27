module Finances::AccountsHelper
  def input_classes(has_errors = false)
    if has_errors
      "w-full py-2 px-3 bg-neutral-100 dark:bg-neutral-800 rounded-lg border-2 border-red-500 focus:border-neutral-500"
    else
      "w-full py-2 px-3 bg-neutral-100 dark:bg-neutral-800 rounded-lg border-2 border-neutral-300 dark:border-neutral-700 focus:border-neutral-500"
    end
  end
end
