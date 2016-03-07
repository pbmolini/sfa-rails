class SfaBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder

	# Custom Builder that adds the active page's title as the last breadcrumb
	def render
    @elements.collect do |element|
      render_element(element)
    end.push(@options[:active_bc_title]).compact.join(@options[:separator] || " &rarr; ")
  end
	
	
end