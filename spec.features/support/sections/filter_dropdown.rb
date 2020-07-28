module Sections
  class FilterDropdown < Filter
    def filter(filter)
      trigger.click
      wait_until_true { has_filter_menu? }
      filter_menu.combobox.set filter
    end

    def reset
      trigger.click
      filter_menu.clear.click
    end
  end
end
