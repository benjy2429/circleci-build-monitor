require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class Project
  attr_accessor :author, :repo, :activity, :url, :last_build_status,
                :build_number, :last_build_time

  ACTIVITY_BUILDING = 'Building'.freeze
  ACTIVITY_SLEEPING = 'Sleeping'.freeze

  STATUS_SUCCESS = 'Success'.freeze
  STATUS_FAILURE = 'Failure'.freeze
  STATUS_UNKNOWN = 'Unknown'.freeze

  def initialize(params = {})
    @author, @repo = params.fetch(:name, '<NO_AUTHOR>/<NO_REPO>').split('/')
    @activity = params.fetch(:activity, ACTIVITY_SLEEPING)
    @url = params.fetch(:webUrl, '')
    @last_build_status = params.fetch(:lastBuildStatus, STATUS_UNKNOWN)
    @build_number = params.fetch(:lastBuildLabel, '?')
    @last_build_time = begin
      DateTime.parse(params.fetch(:lastBuildTime, '')).utc
    rescue ArgumentError
      Time.now.utc
    end
  end

  def building?
    activity == ACTIVITY_BUILDING
  end

  def success?
    last_build_status == STATUS_SUCCESS
  end

  def time_since_last_build
    if building?
      'Building...'
    else
      time_ago_in_words(last_build_time) + ' ago'
    end
  end
end
