require 'spec_helper'

describe ReleaseAutomation::Versioner do

	#some helper methods for versioner
	def create_version_properties_file
		version_props_dir = get_ua_working_dir
		version_props_file = "#{version_props_dir}/version.properties"

		FileUtils.mkdir_p version_props_dir

		File.open(version_props_file, 'w') { |file| 

			file.write("release.version=1\n")
			file.write("snapshot.version=21\n")
		}

	end

	def cleanup_version_properties_file
		version_props_dir = get_ua_working_dir
		version_props_file = "#{version_props_dir}/version.properties"

		FileUtils.rm version_props_file

	end

	before :all do
		setup_testing_build_environment
		@versioner = ReleaseAutomation::Versioner.new

	end

	after :all do
		cleanup_testing_build_environment
	end	

	before :each do
		create_version_properties_file
	end

	after :each do
		cleanup_version_properties_file
	end

	describe "#new" do
		it "should not raise an exception on instantiation" do
			lambda { versioner = ReleaseAutomation::Versioner.new }.should_not raise_exception
		end

		it "should return a new ReleaseAutomation::Versioner object" do
			@versioner.should be_an_instance_of ReleaseAutomation::Versioner
		end

		it "should instantiate a new ReleaseAutomation::Environment::BuildEnvironment object" do 
			@versioner.build_env.should be_an_instance_of ReleaseAutomation::Environment::BuildEnvironment
		end
		
	end

	describe "#bump_build_version" do

		it "should respond to the bump_build_version method call" do
			@versioner.should respond_to(:bump_build_version).with(1).argument
		end

		it "should increment the snapshot version in the version.properties file" do

			#Stub out a mock object for build_scm 
			build_scm = double(ReleaseAutomation::BuildSCM)
			build_scm.stub(:list_jiras_since_commit_message) do 
				"UAR-6, UAR-12, KCI-1123"
			end
			build_scm.stub(:commit_ua_changes)

			old_snashot_number = get_snapshot_version
			
			@versioner.bump_build_version build_scm

			new_snapshot_number = get_snapshot_version

			expected_number = old_snashot_number + 1

			new_snapshot_number.should equal expected_number
		end
	end

	describe "#release" do

		it "should respond to the release method call" do
			@versioner.should respond_to(:release)
		end
		it "should return the current release version" do
			@versioner.release.should equal 1
		end
	end

	describe "#snapshot" do

		it "should respond to the snapshot method call" do
			@versioner.should respond_to(:snapshot)
		end
		it "should return the current snapshot version" do
			@versioner.snapshot.should equal 21
		end
	end

end