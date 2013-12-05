require 'spec_helper'

describe ReleaseAutomation::BuildSCM do

	before :all do
		setup_testing_build_environment
		@build_scm = ReleaseAutomation::BuildSCM.new
	end
	
	after :all do
		cleanup_testing_build_environment
	end

	#Local Helper methods
	def add_changes_helper ( working_dir )

		test_changes_file = "#{working_dir}/test.txt"
		
		File.open(test_changes_file, 'w') { |file| 

			t = Time.now
			file.write(t.nsec)

		}

		`cd #{working_dir}; git add "--" "."  2>&1 ;`

	end

	def commit_changes_helper ( working_dir, message )
		puts `echo "committing changes"; cd #{working_dir}; pwd; git status; git add . ; git status; git commit "--message=#{message}" "--all"  2>&1; git status;`
	end

	describe "#new" do
		it "should not raise an exception on instantiation" do
			lambda { build_scm = ReleaseAutomation::BuildSCM.new }.should_not raise_exception
		end

		it "should return a new ReleaseAutomation::Versioner object" do
			@build_scm.should be_an_instance_of ReleaseAutomation::BuildSCM
		end
	end

	describe "#checkout_source" do

		def check_git_repo ( working_dir )
			File.exist?(working_dir).should be_true
			git_cmd_output = `cd #{working_dir}; git branch`
			git_cmd_output.should include '* automation_testing'
		end

		it "should respond to the checkout_source method call" do
			@build_scm.should respond_to(:checkout_source)
		end

		it "should checkout rice, foundation, ua, and database projects from git" do
			@build_scm.checkout_source

			check_git_repo get_rice_working_dir
			check_git_repo get_foundation_working_dir
			check_git_repo get_ua_working_dir
			check_git_repo get_db_working_dir

		end

	end

	describe "#commit_ua_changes" do

		it "should respond to the commit_ua_changes method call" do
			@build_scm.should respond_to(:commit_ua_changes).with(1).argument
		end

		it "should commit changes to the local ua git repo with the passed in message" do
			
			ua_working_dir = get_ua_working_dir

			add_changes_helper ua_working_dir

			puts `cd #{ua_working_dir}; git add . ;`

			@build_scm.commit_ua_changes("Testing ua project commit")

			last_commit_message = get_last_ua_commit

			last_commit_message.should include "Testing ua project commit"

		end

	end

	describe "#list_jiras_since_commit_message" do

		it "should respond to the list_jiras_since_commit_message method call" do
			@build_scm.should respond_to(:list_jiras_since_commit_message).with(1).argument
		end

		it "should list all jiras found in commit messages since last commit message passed in" do

			
			@build_scm.stub(:_get_commit_messages_for_repository) do
				[
					"UAR-126 bla bla bla", 
					"UAR-125 Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 
					"UAR-124 Sed tristique orci eget convallis condimentum.", 
					"KCI-31234 Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos",
					"All messages after this one should be scanned for jira numbers"
				]
			end
			
			jira_list = @build_scm.list_jiras_since_commit_message "All messages after this one should be scanned for jira numbers"

			jira_list.should eq( " UAR-126, UAR-125, UAR-124, KCI-31234 UAR-126, UAR-125, UAR-124, KCI-31234 UAR-126, UAR-125, UAR-124, KCI-31234 UAR-126, UAR-125, UAR-124, KCI-31234" )

		end

	end
end