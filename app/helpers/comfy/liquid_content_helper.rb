module Comfy::LiquidContentHelper

  def liquid_parse(content)
    p content
    Liquid::Template.parse(content).render(liquid_assigns, registers: liquid_registers)
  end

  # Returns a Hash of available variables, objects or drops that the template
  # can reference. You can create a method +cms_assigns_for+ in you apps
  # application controller to customize the Hash. You can even return
  # custom assigns for different sites, layouts or pages. For example:
  #
  #   def cms_assigns_for(site, layout, page)
  #     defaults = { 'customer' => current_user }
  #     extras = { 'basket' => basket } if layout.identifier == 'shop'
  #     defaults.merge(extras || {})
  #   end
  #
  def liquid_assigns
    if respond_to?(:cms_assigns_for)
      custom_assigns = cms_assigns_for(@cms_site, @cms_layout, @cms_page)
    end

    { 
      'site' => @cms_site.to_liquid,
      'page' => @cms_page.to_liquid, 
      'last_match' => Match.last.to_liquid,
      'next_match' => Match.next.to_liquid,
      'future_matches' => Match.in_future.order('matches.date ASC'),
      'past_matches' =>  Match.in_past.order('matches.date DESC'),
      'posts' => Comfy::Blog::Post.all,
      'post' => @post.to_liquid
    }.merge(custom_assigns || {})
  end

  # Returns a Hash with register variables that can be accessed from Liquid
  # filters and tags.
  # Remember: Use assigns if you want to exposed something to just the page or
  # layout and use registers only within the back-end processing of the template.
  def liquid_registers
    {
      controller: self,
      view: self.view_context
    }
  end
end