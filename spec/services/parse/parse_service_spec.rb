# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parse::ParseService, type: :service do
  describe '.new' do
    context 'given the search engine is google' do
      it 'returns instance of GoogleParseService' do
        search_service = described_class.new(search_engine: 'google', html_code: 'html_code')

        expect(search_service).to be_a(Parse::GoogleParseService)
      end
    end

    context 'given the search engine is bing' do
      it 'returns instance of BingParseService' do
        search_service = described_class.new(search_engine: 'bing', html_code: 'html_code')

        expect(search_service).to be_a(Parse::BingParseService)
      end
    end

    context 'given the search engine is INVALID' do
      it 'raises an error' do
        expect { described_class.new(search_engine: 'yahoo', html_code: 'html_code') }.to raise_error(IcRailsHueyToby::Errors::ParseServiceError)
      end
    end
  end
end
