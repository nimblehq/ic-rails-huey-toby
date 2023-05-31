# frozen_string_literal: true

require 'rails_helper'

describe 'Codebase', codebase: true do
  it 'does not offend Rubocop' do
    expect(`rubocop --parallel --format simple`).to include 'no offenses detected'
  end

  it 'satisfies Brakeman' do
    expect(`brakeman -w2`).not_to include '+SECURITY WARNINGS+'
  end

  it 'does NOT break zeitwerk loading' do
    expect(`bundle exec rake zeitwerk:check`).to include 'All is good!'
  end

  it 'does not offend engine prefix name' do
    engine_paths = Dir[File.expand_path(Rails.root.join('engines', '*'))]
                   .select { |f| File.directory? f }
                   .map { |path| path.split('/').last }
    invalid_engine_paths = engine_paths.reject { |path| path.start_with?('ic_rails_huey_toby_') }

    expect(invalid_engine_paths).to be_empty
  end
end
