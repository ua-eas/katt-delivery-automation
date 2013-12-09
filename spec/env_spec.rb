require 'spec_helper'

describe ReleaseAutomation::Environment do

  before :each do
    @build = ReleaseAutomation::Environment.new
  end

  describe "#new" do
    it "should return a new ReleaseAutomation::Environment object" do
      @build.should be_an_instance_of ReleaseAutomation::Environment
    end
    it "should not raise an exception" do
      lambda { ReleaseAutomation::Environment.new }.should_not raise_exception
    end
  end
end
