class Template < ActiveRecord::Base

  validates_presence_of :name
  validates_format_of :url, :with => URI::regexp(['ftp','http','https']), :allow_nil => true

  # exactly one of URL and HTML must be blank
  validate :provides_html_xor_url

  def provides_html_xor_url
    unless html.blank? ^ url.blank?
      errors.add(:base, 'You must provide either a non-file URL or HTML text (not both)')
    end
  end

  attr_accessible :name, :url, :html


end

