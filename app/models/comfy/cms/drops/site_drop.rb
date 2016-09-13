class Comfy::Cms::Drops::SiteDrop < Liquid::Drop
  def initialize(site)
    @site = site
  end

  def label
    @site.label
  end

  def identifier
    @site.identifier
  end

  def hostname
    @site.hostname
  end

  def path
    @site.path
  end

  def pages
    @site.pages.map(&:to_liquid)
  end

  def locale
    @site.locale
  end
end