require_relative '../lib/release_automation'

module Helpers

	def setup_testing_build_environment
		ReleaseAutomation::set_build_environment_config_file('spec/resources/environment.yaml')
		FileUtils.mkdir_p '/tmp/release_automation/test_build_dir'
	end

	def cleanup_testing_build_environment
		FileUtils.rm_rf '/tmp/release_automation'
	end

	def get_snapshot_version
		version_properties_file = get_ua_working_dir+'version.properties'
		version_properties = JavaProperties::Properties.new(version_properties_file)
		version_properties["snapshot.version"].to_i
	end

	def get_release_version
		version_properties_file = get_ua_working_dir+'version.properties'
		version_properties = JavaProperties::Properties.new(version_properties_file)
		version_properties["release.version"].to_i
	end

	def get_last_ua_commit
		ua_working_dir = get_ua_working_dir
		return `cd #{ua_working_dir}; git log -n 1`
	end

	def get_ua_tags
		return get_tags(get_ua_working_dir)
	end

	def get_foundation_tags
		return get_tags(get_foundation_working_dir)
	end

	def get_db_tags
		return get_tags(get_db_working_dir)
	end

	def get_tags (working_directory) 
		return `cd #{working_directory}; git tag`
	end

	def get_ua_working_dir
		return '/tmp/release_automation/test_build_dir/katt-kc3.1.1-ua/'
	end

	def get_foundation_working_dir
		return '/tmp/release_automation/test_build_dir/katt-kc3.1.1-foundation/'
	end

	def get_db_working_dir
		return '/tmp/release_automation/test_build_dir/katt-kc3.1.1-database-updates/'
	end

	def get_rice_working_dir
		return '/tmp/release_automation/test_build_dir/katt-kc3.1.1-rice1.0.3.3-ua/'
	end

	def string_from_file_helper (resource_name)
		file = File.open("spec/resources/#{resource_name}", "rb")
		file.read
	end

end

RSpec.configure do |c|
  c.include Helpers
end


