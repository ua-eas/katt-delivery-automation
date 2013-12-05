namespace :build  do

	desc "Creates and packages a daily build"
	task :create_build do
		build = ReleaseAutomation::Build.new
		build.create_build
	end
end