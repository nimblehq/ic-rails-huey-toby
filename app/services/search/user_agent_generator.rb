# frozen_string_literal: true

module Search
  module UserAgentGenerator
    USER_AGENT_HEADER = 'User-Agent'

    def generate_user_agent
      Ronin::Web::UserAgents.chrome.random
    end
  end
end
