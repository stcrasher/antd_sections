module NodeExtensions
  include WaitUntilTrueHelper

  def disabled?
    if self[:role] == 'combobox'
      find(:xpath, './parent::div[contains(@class, "ant-select")]')[:class].include?('disabled')
    elsif self[:role] == 'menuitem'
      self[:'aria-disabled'] == 'true'
    elsif tag_name == 'label' || tag_name == 'span'
      self[:class].include? 'disabled' # ant-switcher
    else
      super
    end
  end

  # Hack to trigger React.Dom onChange event
  def clear
    set ' '
    # PhoneNumber inputs have country dial code pre-populated on focus. To have
    # it fully cleared, need more than one "backspace" hit
    wait_until_true do
      native.send_keys :backspace
      value.empty?
    end
  end

  def static?
    rect1 = native.rect
    sleep 0.001
    rect2 = native.rect
    rect1.x == rect2.x && rect1.y == rect2.y && rect1.width == rect2.width && rect1.height == rect2.height
  end

  def enable_element
    enable_element_script = <<~'JS'
      this.removeAttribute("disabled");
      this.className = this.className.replace(/disabled/, 'enabled');
    JS
    execute_script(enable_element_script)
  end

  def selected?
    if tag_name == 'button'
      self[:class].include?('active')
    else
      super
    end
  end
end

Capybara::Node::Element.prepend(NodeExtensions)
