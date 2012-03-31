require 'plate/template'

class Subject
  include Plate::Template
end

describe Plate::Template do
  subject { Subject.new }

  describe '#template' do
    it "returns the path to a template" do
      File.should_receive(:expand_path).with('../../../templates/path/template', anything).and_return('something')
      subject.template('path/template').should == "something"
    end
  end

  describe '#compile_template' do
    it "returns the string for the template" do
      template = subject.template('vhosts/nginx/rails3.erb')
      File.should_receive(:read).with(template).and_return('abcdef <%= app.name %> <%= app.path %>')

      app = stub(
        :name    => 'app1',
        :path    => '/var/app/app1',
        :domain  => 'webby.com',
        :alaises => 'app2.webby.com app3.webby.com'
      )
      
      result = subject.compile_template('vhosts/nginx/rails3.erb', { :app => app })
      result.should == "abcdef app1 /var/app/app1"
    end
  end

  describe '#temp_from_template' do
    let(:file) { stub(:tempfile) }
    it "creates a tempfile with the template contents" do
      Tempfile.should_receive(:new).with('app1.conf').and_return(file)
      file.stub(:path => "/tmp/app1.conf.24722.0")
      subject.should_receive(:create_from_template).with("/tmp/app1.conf.24722.0", "path/app1.conf")
      subject.temp_from_template("path/app1.conf").should == file
    end
  end

  describe '#create_from_template' do
    let(:app)        { stub }
    let(:write_file) { stub }
    
    it "creates a file with the template" do
      subject.should_receive(:compile_template).with('vhosts/nginx/rails3.erb', { :app => app }).and_return('contents')
      write_file.should_receive(:write).with('contents')
      File.should_receive(:open).with('/tmp/app1.conf', 'w').and_yield(write_file)

      subject.create_from_template('/tmp/app1.conf', 'vhosts/nginx/rails3.erb', { :app => app })
    end
    
    it "accepts empty params" do
      subject.should_receive(:compile_template).with('vhosts/nginx/rails3.erb', {}).and_return('contents')
      write_file.should_receive(:write).with('contents')
      File.should_receive(:open).with('/tmp/app1.conf', 'w').and_yield(write_file)

      subject.create_from_template('/tmp/app1.conf', 'vhosts/nginx/rails3.erb')
    end
  end
  
  describe '#display_template' do
    it 'prints out the contents of a template' do
      subject.should_receive(:read_template).with('template').and_return('contents')
      subject.should_receive(:puts).with('contents')
      subject.display_template 'template'
    end
  end
  
  describe '#read_template' do
    it "reads the contents of a template to a string" do
      file = File.expand_path("../../../templates/template", __FILE__)
      File.should_receive(:read).with(file)
      subject.read_template 'template'
    end
  end
end