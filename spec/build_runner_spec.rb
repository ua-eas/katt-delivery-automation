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

	describe "#build" do
		
		it "should respond to the build method call" do
			@build_runner.should respond_to :build
		end

		it "should kick off a maven build in the rice working directory" do
			@command_ran_array = []

			@build_runner.stub(:_run_cmd) do | command |
				@command_ran_array.push command
				string_from_file_helper "sample_mvn_output_success.txt"
			end

			rice_dir 	   = get_rice_working_dir
			foundation_dir = get_foundation_working_dir
			ua_dir 		   = get_ua_working_dir

			expected_commands_array = [
				"cd #{rice_dir}; ./maven.sh",
				"cd #{foundation_dir}; ./maven.sh",
				"cd #{ua_dir}; ./maven.sh"
			]

			expect{@build_runner.build}.to_not raise_error

			@command_ran_array.should =~ expected_commands_array

		end

		it "should not raise an exception if the maven build output does not contain '[ERROR] BUILD ERROR'" do
			@build_runner.stub :_run_cmd do
				string_from_file_helper "sample_mvn_output_success.txt"
			end

			expect{@build_runner.build}.to_not raise_error
			
		end

		it "should raise an exception if the maven build output contains '[ERROR] BUILD ERROR'" do
			@build_runner.stub :_run_cmd do
				string_from_file_helper "sample_mvn_output_failure.txt"
			end

			expect{@build_runner.build}.to raise_error(ReleaseAutomation::BuildError)
			
		end
	end

end