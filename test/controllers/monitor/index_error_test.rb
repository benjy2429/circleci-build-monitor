require 'test_helper'

class MonitorControllerTest < ActionController::TestCase
  test 'Returns an empty project list when a timeout occurs' do
    stub_request(:get, /.*circleci.*/).to_timeout
    stub_config
    get :index
    assert_select('.project', false, 'Projects is not empty')
    assert_select('.error', 'Failed to fetch data from the server.',
                  'Error message not displayed')
  end

  test 'Returns an empty project list when an API error occurs' do
    stub_request(:get, /.*circleci.*/).to_return(status: 500)
    stub_config
    get :index
    assert_select('.project', false, 'Projects is not empty')
    assert_select('.error', 'Failed to fetch data from the server.',
                  'Error message not displayed')
  end

  test 'Returns an empty project list when the API returns no projects' do
    stub_test_xml('invalid_cc.xml')
    stub_config
    get :index
    assert_select('.project', false, 'Projects is not empty')
    assert_select('.error',
                  'No projects returned. Maybe your token is invalid?',
                  'Error message not displayed')
  end
end
