module Sections
  class Filter < Base
    element :trigger, '.ant-dropdown-trigger'

    section :filter_menu, :xpath, "//div[contains(concat(' ', normalize-space(@class), ' '), ' ant-table-filter-dropdown ')][//li]" do
      sections :checks,   Sections::Checkbox, 'li'
      section  :combobox, Sections::Combobox, '[role="combobox"]'
      element  :clear,    '.ant-select-selection__clear'
      element :ok_btn,    :xpath, './div/a[text()="OK"]'
      element :reset_btn, :xpath, './div/a[text()="Reset"]'
    end

    def filter(filters)
      trigger.click
      wait_until_true { has_filter_menu? }
      filters.each do |check|
        filter_menu.checks(text: check, match: :prefer_exact).first.check
      end
      filter_menu.ok_btn.click
    end

    def reset
      trigger.click
      sleep 1
      filter_menu.reset_btn.click
    end
  end
end
