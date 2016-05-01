require 'test_helper'

class MonitorControllerTest < ActionController::TestCase
  def stub_test_xml(filename)
    WebMock.reset!
    stub_request(:get, /.*circleci.*/)
      .to_return(body: File.read(
        Rails.root.join("test/fixtures/files/#{filename}")))
  end

  def stub_config(filename = nil)
    if filename
      @controller.expects(:load_config_file)
                 .returns(YAML.load_file("test/fixtures/files/#{filename}"))
    else
      @controller.expects(:load_config_file).returns([])
    end
  end
end
