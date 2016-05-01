require 'test_helper'

class MonitorControllerTest < ActionController::TestCase
  test 'Should return index' do
    stub_test_xml('success_cc.xml')
    get :index
    assert_response :success
  end

  test 'Displays the repo name' do
    stub_test_xml('success_cc.xml')
    stub_config
    get :index
    assert_select('.name', 'success-project', 'Repo name was not visible')
  end

  test 'Displays the build number' do
    stub_test_xml('success_cc.xml')
    stub_config
    get :index
    assert_select('.build-number', '#1', 'Build number was not visible')
  end

  test 'Displays the time since last build' do
    stub_test_xml('success_cc.xml')
    stub_config
    get :index
    assert_select('.time-ago', 'less than a minute ago',
                  'Time since last build was not visible')
  end

  test 'Displays a successful build in green' do
    stub_test_xml('success_cc.xml')
    stub_config
    get :index
    assert_select('.project.success', { count: 1 },
                  'Successful project not displayed')
    assert_select('.name', 'success-project', 'Repo name was not visible')
  end

  test 'Displays a failing build in red' do
    stub_test_xml('failure_cc.xml')
    stub_config
    get :index
    assert_select('.project.failure', { count: 1 },
                  'Failed project not displayed')
    assert_select('.name', 'failure-project', 'Repo name was not visible')
  end

  test 'Displays an unknown build in grey' do
    stub_test_xml('unknown_cc.xml')
    stub_config
    get :index
    assert_select('.project.unknown', { count: 1 },
                  'Unknown status project not displayed')
    assert_select('.name', 'unknown-project', 'Repo name was not visible')
  end

  test 'Displays a building project in blue' do
    stub_test_xml('building_cc.xml')
    stub_config
    get :index
    assert_select('.project.building', { count: 1 },
                  'Building project not displayed')
    assert_select('.name', 'building-project', 'Repo name was not visible')
  end

  test 'Returns an empty project list when a timeout occurs' do
    stub_request(:get, /.*circleci.*/).to_timeout
    stub_config
    get :index
    assert_select('.project', false, 'Projects is not empty')
  end

  test 'Returns an empty project list when an API error occurs' do
    stub_request(:get, /.*circleci.*/).to_return(status: 500)
    stub_config
    get :index
    assert_select('.project', false, 'Projects is not empty')
  end

  test 'All projects are returned with no config file' do
    stub_test_xml('multiple_cc.xml')
    stub_config
    get :index
    assert_select('.project', { count: 2 },
                  'Only 2 projects should be displayed')
    assert_select('.project.success', { count: 1 },
                  'Successful project not displayed')
    assert_select('.project.failure', { count: 1 },
                  'Failed project not displayed')
    assert_select('.project.success .name', 'project1',
                  'First project name was not visible')
    assert_select('.project.failure .name', 'project2',
                  'Second project name was not visible')
  end

  test 'Config file restricts the projects shown' do
    stub_test_xml('multiple_cc.xml')
    stub_config('sample_projects.yml')
    get :index
    assert_select('.project', { count: 1 },
                  'Only 1 project1 should be displayed')
    assert_select('.project .name', 'project2',
                  'Second project name was not visible')
  end
end
