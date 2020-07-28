module Sections
  class Phone < Combobox
    include ::Pages::Mixings::Spinnable::Loader

    def_delegators :input, :clear, :value, :disabled?
    element :error, '.error'

    section :country_select, Sections::Combobox, '[data-name="country"]' do
      def expand_list
        Capybara.page.driver.click(-1000, -1000)
        country_code_value.click unless root_element[:'aria-expanded'] == 'true'
      end

      element :country_code_value, :xpath, './/div[@data-name]'

      def country_code
        country_code_value['data-name']
      end
    end

    def select_country(country)
      country_select.set country
    end

    def select(value, **)
      root_element.click if root_element[:'aria-expanded'] == 'false'

      wait_until_true do
        input.clear
        input.set(value)
        input.value.gsub(/\D/, '') == value.gsub(/\D/, '')
      end
    end
    alias set select

    def stripped_value
      input.value.delete('^+0-9')
    end
  end
end
