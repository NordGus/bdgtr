module ApplicationHelper
  def menu_item_classes(item_controller:, current_controller:)
    if item_controller == current_controller
      "block flex-1 py-2 px-3 text-center rounded-lg bg-neutral-300 dark:bg-neutral-700 underline"
    else
      "block flex-1 py-2 px-3 text-center rounded-lg hover:bg-neutral-300 hover:dark:bg-neutral-700 hover:underline"
    end
  end
end
