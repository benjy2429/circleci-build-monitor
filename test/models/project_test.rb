require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'Default author is saved' do
    project = Project.new
    assert_equal('<NO_AUTHOR>', project.author,
                 'Default author was not returned')
  end

  test 'Default repo is saved' do
    project = Project.new
    assert_equal('<NO_REPO>', project.repo, 'Default repo was not returned')
  end

  test 'Default activity is saved' do
    project = Project.new
    assert_equal('Sleeping', project.activity,
                 'Default activity was not returned')
  end

  test 'Default url is saved' do
    project = Project.new
    assert_equal('', project.url, 'Default url was not returned')
  end

  test 'Default last build status is saved' do
    project = Project.new
    assert_equal('Unknown', project.last_build_status,
                 'Default last build status was not returned')
  end

  test 'Default build number is saved' do
    project = Project.new
    assert_equal('?', project.build_number,
                 'Default build number was not returned')
  end

  test 'Default last build time is saved' do
    project = Project.new
    assert_in_delta(Time.now.utc, project.last_build_time, 1.second,
                    'Default last build time was not returned')
  end

  test 'Time since last build returns time when not building' do
    one_hour_ago = (Time.now.utc - 1.hour).strftime('%Y-%m-%dT%H:%M:%S.%LZ')
    project = Project.new(activity: 'Sleeping',
                          lastBuildTime: one_hour_ago)
    assert_equal('about 1 hour ago', project.time_since_last_build,
                 'Building project returned time for time_since_last_build')
  end

  test 'Time since last build returns "Building..." when building' do
    project = Project.new(activity: 'Building')
    assert_equal('Building...', project.time_since_last_build,
                 'Building project returned time for time_since_last_build')
  end
end
