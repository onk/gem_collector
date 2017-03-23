class GemCollector::RepositoryGem < GemCollector::ApplicationRecord
  module Status
    UNKNOWN  = 0
    OUTDATED = 1 # behind mejor version
    BEHIND   = 2
    LATEST   = 3
  end

  def self.status(locked_version_str, latest_version_str)
    return Status::UNKNOWN unless latest_version_str

    locked_version = Gem::Version.new(locked_version_str)
    latest_version = Gem::Version.new(latest_version_str)
    return Status::LATEST if latest_version <= locked_version

    locked_requirement = Gem::Requirement.new(locked_version.approximate_recommendation)
    locked_requirement.satisfied_by?(latest_version) ? Status::BEHIND : Status::OUTDATED
  end
end
