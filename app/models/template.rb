class Template < ActiveRecord::Base

  # A representation of a page template, which must provide either a URL or a block of HTML
  # but not both.
  attr_accessible :name, :url, :html
  validates_presence_of :name
  validates_format_of :url, :with => URI::regexp(['ftp','http','https']), :allow_blank => true

  # exactly one of URL and HTML must be blank
  validate :provides_html_xor_url

  def provides_html_xor_url
    unless html.blank? ^ url.blank?
      errors.add(:base, 'You must provide either a non-file URL or HTML text (not both)')
    end
  end

  # Return the template's HTML content.  In the future can also fetch and cache external URLs.
  def content
    if url.blank?
      html
    else
      raise RuntimeError, "Template#content cannot handle external URLs yet"
    end
  end

end

