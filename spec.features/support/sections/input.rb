module Sections
  class Input < Combobox
    include ::Pages::Mixings::Spinnable::Loader
    element :input, :xpath, './ancestor-or-self::input | ./ancestor-or-self::textarea'

    element :error, :xpath, "./ancestor::div/*[contains(@class, 'error')]"

    def set(value)
      if value.to_s.empty?
        input.clear
      else
        input.set value
      end
    end

    def_delegators :input, :clear, :value
  end
end
