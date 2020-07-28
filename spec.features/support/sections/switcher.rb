module Sections
  class Switcher < Spinnable
    element :switch, :xpath, '.'

    def_delegators :switch, :click, :disabled?, :[]

    def check
      switch.click unless checked?
      sleep(0.3)
    end

    def uncheck
      switch.click if checked?
      sleep(0.3)
    end

    def checked?
      case switch.tag_name
      when 'label', 'button', 'div', 'span'
        switch[:class].include?('checked') || switch[:class].include?('active')
      else
        switch.checked?
      end
    end

    def unchecked?
      !checked?
    end
    alias selected? checked?
  end
end
