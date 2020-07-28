module Sections
  class Multiselect < Combobox
    class SelectionChoice < Base
      element :name, '.ant-select-selection__choice__content'
      element :remove_btn, '.ant-select-selection__choice__remove'

      def remove
        remove_btn.click
      end

      def_delegators :name, :text
    end

    sections :selected, SelectionChoice, 'li[role="presentation"]'

    def select(value, *)
      super
    end

    def selected_options
      sleep(0.5)
      wait_for(timeout: 5) { selected(wait: 0).map(&:text) }
    end

    def remove(value)
      selected.find { |o| o.text == value }&.remove
    end
    alias unselect remove
  end
end
