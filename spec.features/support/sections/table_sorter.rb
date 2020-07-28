module Sections
  class TableSorter < Base
    element :up, '.ant-table-column-sorter-up'
    element :down, '.ant-table-column-sorter-down'

    def up?
      up['class'] =~ / on/
    end

    def down?
      down['class'] =~ / on/
    end

    def sort_up
      counter = 0
      while !up? && counter < 2
        counter += 1
        root_element.click
      end
      raise "Cannot sort up" unless up?
    end

    def sort_down
      counter = 0
      while !down? && counter < 2
        counter += 1
        root_element.click
      end
      raise "Cannot sort down" unless down?
    end

    def sort_default
      counter = 0
      while (down? || up?) && counter < 2
        counter += 1
        root_element.click
      end
      raise "Cannot reset sorting" if up? || down?
    end
  end
end
