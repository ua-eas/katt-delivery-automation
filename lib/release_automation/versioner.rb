# Public: This class is responsible updating the version of delivered software.
#
class ReleaseAutomation::Versioner

	delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

	attr_reader :build_env, :release, :snapshot

	def initialize
		@logger = ReleaseAutomation::get_logger
		@build_env = _initialize_build_environemnt
	end

	def bump_build_version ( scm )

		new_snapshot_version = snapshot + 1

		debug "snapshot.version bumped from #{snapshot} to #{new_snapshot_version}"

		debug "writing java properties file: " + _version_properties_file
		
		File.open(_version_properties_file, 'w') { |file| 

			property = "snapshot.version=#{new_snapshot_version}"
			debug "writing:" + property
			file.write(property + "\n")

			property = "release.version=#{release}"
			debug "writing:" + property
			file.write(property)

		}

		fixed_jiras = scm.list_jiras_since_commit_message('Bumping snapshot version')

		commit_message = "Bumping snapshot version to #{new_snapshot_version} for release #{release}"
		commit_message += " with fixes for #{fixed_jiras}"

		debug "commiting changes with message: #{commit_message}"

		scm.commit_ua_changes( commit_message )

		debug "End ReleaseAutomation::Versioner::bump_build_version"

	end

	def release 
		props = _version_properties
		props['release.version'].to_i
	end

	def snapshot
		props = _version_properties
		props['snapshot.version'].to_i
	end

	private

	def _initialize_build_environemnt
		ReleaseAutomation::get_build_environment
	end

	def _version_properties
		@props ||= JavaProperties::Properties.new(_version_properties_file)
	end

	def _version_properties_file
		build_env.get_version_properties_file
	end

end