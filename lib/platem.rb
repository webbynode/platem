require "platem/version"
require "platem/template"

module Platem
  class << self
    attr_accessor :template_root
  end

  def template_root(root)
    Platem.template_root = root
  end
end
