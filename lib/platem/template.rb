require 'ostruct'
require 'tempfile'

module Platem
  module Template
    class ErbBinding < OpenStruct
      def get_binding
        binding
      end
    end

    def template(template)
      File.expand_path("../../../templates/#{template}", __FILE__)
    end

    def compile_template(template, vars)
      contents = File.read(template(template))
      struct = ErbBinding.new(vars)
      ERB.new(contents).result(struct.send(:get_binding))
    end

    def create_from_template(file, template, vars = {})
      File.open(file, 'w') { |f| f.write compile_template(template, vars) }
    end

    def temp_from_template(template)
      Tempfile.new(File.basename(template)).tap do |file|
        create_from_template file.path, template
      end
    end
    
    def template(template)
      File.expand_path("../../../templates/#{template}", __FILE__)
    end

    def display_template(template)
      puts read_template(template)
    end
    
    def read_template(template)
      File.read template(template)
    end
  end
end