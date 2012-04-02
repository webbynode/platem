require "platem/version"
require "platem/template"

module Platem
  class << self
    attr_accessor :template_root
  end

  module ClassMethods
    def template_root(root)
      Platem.template_root = root
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
    klass.send(:include, Platem::Template)
  end

end
