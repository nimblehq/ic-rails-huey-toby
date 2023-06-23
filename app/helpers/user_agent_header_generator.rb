# frozen_string_literal: true

class UserAgentHeaderGenerator
  USER_AGENT_HEADER = 'User-Agent'

  def self.call
    { USER_AGENT_HEADER => Ronin::Web::UserAgents.chrome.random }
  end
end
