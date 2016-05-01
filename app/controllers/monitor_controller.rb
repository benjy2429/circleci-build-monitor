require 'open-uri'

class MonitorController < ApplicationController
  # GET /
  def index
    @projects = build_project_list
  end

  private

  # Fetch the latest data from the API and convert to a Hash
  def fetch_data
    data = open(
      "#{Rails.configuration.circleci_url}"\
      "#{Rails.configuration.circleci_token}",
      read_timeout: 10).read

    clean_data(Hash.from_xml(data))

  rescue OpenURI::HTTPError, Timeout::Error => e
    Rails.logger.error "Failed to fetch data: #{e.message}"
    @error = 'Failed to fetch data from the server.'
    []
  end

  # Clean the hash and extract the projects
  def clean_data(data)
    data.deep_symbolize_keys!

    unless data[:Projects] && data[:Projects][:Project]
      @error = 'No projects returned. Maybe your token is invalid?'
      return []
    end

    parsed_data = data[:Projects][:Project]
    parsed_data.is_a?(Array) ? parsed_data : [parsed_data]
  end

  # Create new Project objects from the data and add them to an array
  def build_project_list
    data = fetch_data
    projects = []
    selected_project_names = load_config_file

    data.each do |project|
      next if selected_project_names && selected_project_names.any? &&
              selected_project_names.exclude?(project[:name])
      projects << Project.new(project)
    end
    projects
  end

  # Read the project config file
  def load_config_file
    YAML.load_file('config/projects.yml')
  rescue Errno::ENOENT
    []
  end
end
