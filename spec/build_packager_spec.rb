require 'spec_helper'

describe ReleaseAutomation::BuildRunner do


  before :all do
    setup_testing_build_environment
    @build_runner = ReleaseAutomation::BuildRunner.new
  end

  after :all do
    cleanup_testing_build_environment
  end

  describe "#new" do
    it "should not raise an exception on instantiation" do
      lambda { build_scm = ReleaseAutomation::BuildRunner.new }.should_not raise_exception
    end

    it "should return a new ReleaseAutomation::BuildRunner object" do
      @build_runner.should be_an_instance_of ReleaseAutomation::BuildRunner
    end
  end

  describe "#package" do

    it "should respond to the package method call" do
      @build_runner.should respond_to :package
    end




  end

end
