module Sections
  class Combobox < Spinnable
    element :input, 'input'

    element :label,    :xpath, './ancestor::div[@data-name]//label'
    elements :options, :xpath, '//li[@role="option"]'

    def available_options(wait: true)
      expand_list
      if wait
        wait_until_true do
          # if wait is true we want to wait for at least one element is there
          options_present = options(wait: 1).present?
          # all? returns true on an empty array
          options_present && options.map(&:text).all?(&:present?)
        end
      end
      rejected_options = ['Select All', 'Deselect All', '']
      options.reject { |o| o['class'] =~ /disabled/ }.map(&:text) - rejected_options
    ensure
      collapse_list
    end

    def expand_list
      root_element.click unless root_element[:'aria-expanded'] == 'true'
    end

    def collapse_list
      wait_until_true(timeout: 5) do
        break true if root_element[:'aria-expanded'] == 'false'

        Capybara.page.driver.click(-1000, -1000)
        sleep(0.5)
      end
    end

    element :error, :xpath, './parent::div[contains(@class, "ant-select")]/following::div[contains(@class, "error")][position()=1]'

    element :selected, '.ant-select-selection-selected-value'

    def select(value, **_options)
      return value if selected_options == value

      expand_list
      sleep(0.3)
      wait_until_true(timeout: 10) { options(text: value.to_s, visible: true).first }
      options(text: value.to_s, visible: true).first.click
      collapse_list
    end
    alias set select

    def selected_options
      has_selected?(wait: 0) && selected.text || ''
    end

    def error_message
      error.text
    end

    def select_first
      expand_list
      sleep(0.3)
      wait_until_true(timeout: 10) { options(visible: true).first }
      options(visible: true).first.click
      collapse_list
    end

    def_delegators :root_element, :disabled?
  end
end
