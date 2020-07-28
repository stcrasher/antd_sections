module Sections
  class Pagination < SitePrism::Section
    element :prev_page, '.ant-pagination-prev'
    element :next_page, '.ant-pagination-next'
    element :next_pages, '.ant-pagination-jump-next'
    element :first_page, :xpath, './/li[2]'
    element :last_page, :xpath, './/li[last()-1]'
    element :current_page, '.ant-pagination-item-active'

    def select_page(num)
      find(:xpath, ".//li[@title='#{num}']").click
    end

    def pages_count
      last_page.text.to_i
    end
  end
end
