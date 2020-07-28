module Sections
  class Modal < Base
    element :title, '.ant-modal-title'
    element :body, '.ant-modal-body'
    element :cancel_button, 'button', text: /Cancel|Close|No/
    element :save_button, 'button', text: /Save|Submit|OK|Ok|Got it|Yes|Proceed|Continue/
    element :x_cross_button, '.ant-modal-close-x'

    def submit
      sleep(0.5)
      save_button.click
      sleep(0.5)
    end

    def cancel
      sleep(0.5)
      cancel_button.click
      sleep(0.5)
    end
  end
end
