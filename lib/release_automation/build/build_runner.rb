class ReleaseAutomation::BuildRunner
	
	delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

	attr_reader :build_environment

	def initialize
		@logger = ReleaseAutomation::get_logger
		@build_environment = _initialize_build_environment
	end

	def build

		_build_rice
		_build_foundation
		_build_ua

	end

	private

	def _build_rice
		rice_working_dir = build_environment.get_rice_working_dir
		
		rice_build_cmd = "cd #{rice_working_dir}; ./maven.sh"
		
		build_output = _run_cmd rice_build_cmd

		if build_output =~ /\[ERROR\] BUILD ERROR/

			raise ReleaseAutomation::BuildError, 'Rice maven build filed'

		end
		
	end

	def _build_foundation
		foundation_working_dir = build_environment.get_foundation_working_dir

		foundation_build_cmd = "cd #{foundation_working_dir}; ./maven.sh"

		build_output = _run_cmd foundation_build_cmd

		if build_output =~ /\[ERROR\] BUILD ERROR/

			raise ReleaseAutomation::BuildError, 'Foundation maven build filed'

		end
		
	end

	def _build_ua
		ua_working_dir = build_environment.get_ua_working_dir

		ua_build_cmd = "cd #{ua_working_dir}; ./maven.sh"

		build_output = _run_cmd ua_build_cmd

		if build_output =~ /\[ERROR\] BUILD ERROR/

			raise ReleaseAutomation::BuildError, 'UA maven build filed'

		end
		
	end

	def _run_cmd (cmd)
		cmd = "#{cmd} 2>&1;"
		info "running command: #{cmd}"
		
		run_output = `#{cmd}`
		
		info run_output
		
		return run_output
	end

	def _initialize_build_environment
		ReleaseAutomation::get_build_environment
	end
end

class ReleaseAutomation::BuildError < StandardError
end