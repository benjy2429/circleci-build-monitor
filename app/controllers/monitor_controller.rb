require 'open-uri'

class MonitorController < ApplicationController
  def index
    @projects = parse_projects(fetch_data) || []
  end

  private

  def fetch_data
    data = open(
      "#{Rails.configuration.circleci_url}"\
      "#{Rails.configuration.circleci_token}",
      read_timeout: 10).read

    # data = open('cc.xml').read
    parsed_data = Hash.from_xml(data).deep_symbolize_keys![:Projects][:Project]

    parsed_data.is_a?(Array) ? parsed_data : [parsed_data]

  rescue OpenURI::HTTPError, Timeout::Error => e
    Rails.logger.error "Failed to fetch data: #{e.message}"
    []
  end

  def parse_projects(xml)
    projects = []
    selected_projects = load_config_file

    xml.each do |xml_data|
      next if selected_projects.any? &&
              selected_projects.exclude?(xml_data[:name])
      projects << Project.new(xml_data)
    end
    projects.sort_by(&:repo)
  end

  def load_config_file
    YAML.load_file('config/projects.yml')
  rescue Errno::ENOENT
    []
  end
end
