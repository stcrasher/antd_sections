module Sections
  class GoogleMap < Base
    include DrawHelper
    element :attached_div, :xpath, '../../../../.'

    element :zoom_in,  :xpath, './..//button[@aria-label="Zoom in"]'
    element :zoom_out, :xpath, './..//button[@aria-label="Zoom out"]'

    load_validation { [has_attached_div? && attached_div['class'] =~ /mapLoaded/, 'Map was not loaded'] }

    def draw_poligon(points = [[-50, 50], [50, 50], [50, -50]])
      super(self, points)
    end

    def zoom_in_out
      wait_until_true { has_zoom_in? && has_zoom_out? }
      zoom_in.click
      zoom_out.click
    end
  end
end
