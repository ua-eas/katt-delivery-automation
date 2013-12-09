namespace :release  do

  desc "Merges the provided branches into staging to prepare for an release cadidate build."
  task :merge_feature_branches_to_staging, branches do
    #TODO
  end

  namespace :release_cadidate

  desc "Performs prebuild steps to prepare source for release cadidate build."
  task :pre_build, branches do
  end

  desc "Performs prebuild steps to prepare source for release cadidate build."
  task :pre_build, branches do
  end

end

desc "Merges the provided branches into staging to prepare for an release cadidate build."
task :prepare_release_cadidate_build, branches do
  #TODO
end

end
