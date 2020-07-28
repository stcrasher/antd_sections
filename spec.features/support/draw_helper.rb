module Selenium
  module WebDriver
    class ActionBuilder
      def pause(seconds)
        @devices.merge!(self: self) unless @devices[:self]
        @actions << [:self, :sleep, seconds]
        self
      end

      def screenshot(file)
        @devices.merge!(screen: Capybara.page) unless @devices[:screen]
        @actions << [:screen, :save_screenshot, file]
        self
      end
    end
  end
end

module DrawHelper
  def draw_poligon(element, points)
    element = element.root_element unless element.is_a?(Capybara::Node::Element)
    driver = parent_page.page.driver
    center = element.native.visible_center

    (points + [points[0]]).each do |x, y|
      driver.click(center[:x] + x, center[:y] + y)
      sleep(0.5)
    end
  end
end
