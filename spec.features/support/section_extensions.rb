module SectionExtension
  delegate :static?, to: :root_element
end

SitePrism::Section.prepend SectionExtension
