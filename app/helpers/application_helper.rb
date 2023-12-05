module ApplicationHelper
  def menu_item_classes(item_controller:, current_controller:)
    base = "flex flex-col justify-center items-center flex-1 py-2 px-3 rounded-lg text-xs"

    if item_controller == current_controller
      "#{base} bg-neutral-300 dark:bg-neutral-700 underline"
    else
      "#{base} hover:bg-neutral-300 hover:dark:bg-neutral-700"
    end
  end
end
