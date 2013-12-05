require 'spec_helper'

describe ReleaseAutomation::BuildPreparer do

	before :all do
		setup_testing_build_environment
		@build_preparer = ReleaseAutomation::BuildPreparer.new
	end

	after :all do
		#cleanup_testing_build_environment
	end	

	describe "#new" do
		it "should not raise an exception on instantiation" do
			lambda { build_preparer = ReleaseAutomation::BuildPreparer.new }.should_not raise_exception
		end

		it "should return a new ReleaseAutomation::BuildPreparer object" do
			@build_preparer.should be_an_instance_of ReleaseAutomation::BuildPreparer
		end

		it "should instantiate a new build_scm object" do 
			@build_preparer.build_scm.should be_an_instance_of ReleaseAutomation::BuildSCM
		end

		it "should instantiate a new versioner object" do 
			@build_preparer.version.should be_an_instance_of ReleaseAutomation::Versioner
		end
		
	end

	describe "#prepare" do
		it "should respond to the prepare method call" do
			@build_preparer.should respond_to(:prepare)
		end
	end

end