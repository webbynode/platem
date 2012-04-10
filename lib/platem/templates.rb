require 'ostruct'
require 'tempfile'

module Platem
  module Templates
    class ErbBinding < OpenStruct
      def get_binding
        binding
      end
    end

    def compile_template(template, vars)
      contents = File.read(template_file(template))
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
    
    def template_file(template)
      File.join(Platem.template_root, template)
    end

    def display_template(template)
      puts read_template(template)
    end
    
    def read_template(template)
      File.read template_file(template)
    end
  end
end