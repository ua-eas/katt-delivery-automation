require 'spec_helper'

describe ReleaseAutomation::Build do
	
	before :all do
		setup_testing_build_environment
		@build = ReleaseAutomation::Build.new
	end

	after :all do
		cleanup_testing_build_environment
	end	

	describe "#new" do
		it "should return a new ReleaseAutomation::Build object" do
			@build.should be_an_instance_of ReleaseAutomation::Build
		end
		it "should not raise an exception" do
			lambda { ReleaseAutomation::Build.new }.should_not raise_exception
		end
	end

	describe "#create_build" do
		it "should respond to create_build" do
			@build.should respond_to :create_build
		end
	end

end




# describe ReleaseAutomation::Build do
	
# 	before :all do
# 		setup_testing_build_environment
# 		@build = ReleaseAutomation::Build.new
# 	end

# 	after :all do
# 		#cleanup_testing_build_environment
# 	end

# 	describe "#new" do
# 		it "should return a new ReleaseAutomation::Build object" do
# 			@build.should be_an_instance_of ReleaseAutomation::Build
# 		end
# 		it "should not raise an exception" do
# 			lambda { ReleaseAutomation::Build.new }.should_not raise_exception
# 		end
# 	end

# 	describe "#checkout_foundation_source" do
# 		it "should clone the foundation source project and checkout the configured branch from environment.yaml" do
# 			@build.checkout_foundation_source
# 			git_cmd_output = `cd /tmp/release_automation/test_build_dir/katt-kc3.1.1-foundation/; git branch`
# 			git_cmd_output.should include '* automation_testing'

# 		end
# 	end

# 	describe "#checkout_ua_source" do
# 		it "should clone the ua source project and checkout the configured branch from environment.yaml" do
# 			@build.checkout_ua_source
# 			git_cmd_output = `cd /tmp/release_automation/test_build_dir/katt-kc3.1.1-ua/; git branch`
# 			git_cmd_output.should include '* automation_testing'

# 		end
# 	end

# 	describe "#checkout_database_updates" do
# 		it "should clone the database updates project and checkout the configured branch from environment.yaml" do
# 			@build.checkout_database_updates
# 			git_cmd_output = `cd /tmp/release_automation/test_build_dir/katt-kc3.1.1-database-updates/; git branch`
# 			git_cmd_output.should include '* automation_testing'

# 		end
# 	end

# 	describe "#bump_build_version" do
# 		it "should bump the snapshot.version in version.properties and commit changes" do
# 			old_snashot_number = get_snapshot_version
# 			old_commit = get_last_commit
			
# 			@build.bump_build_version

# 			new_snapshot_number = get_snapshot_version
# 			new_commit = get_last_commit

# 			expected_number = old_snashot_number.to_i + 1

# 			new_snapshot_number.to_i.should equal expected_number

# 			new_commit.should_not equal old_commit

# 			new_commit.should include "Bumping snapshot version to #{new_snapshot_number}"

# 		end
# 	end

# 	describe "#tag_build" do
# 		it "should tag the foundation, ua, database updates, and rice repositories with the build tag." do

# 			@build.tag_build

# 			snapshot_version = get_snapshot_version
# 			release_version = get_release_version
# 			tag = "release-3.1.1-#{release_version}.pre#{snapshot_version}"

# 			foundation_tags = get_foundation_tags
# 			ua_tags = get_ua_tags
# 			db_tags = get_db_tags

# 			foundation_tags.should include tag
# 			ua_tags.should include tag
# 			db_tags.should include tag

# 		end 
# 	end

# 	describe "#package_application" do
# 		it "should move the application .war files into the share drive with the correct name" do
# 			snapshot_version = get_snapshot_version
# 			release_version = get_release_version
# 			tag = "release-3.1.1-#{release_version}.pre#{snapshot_version}"

# 			@build.package_application

# 		end
# 	end
# end