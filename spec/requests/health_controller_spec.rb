# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health Controller', type: :request do
  describe 'GET #show' do
    context 'when the application is up' do
      it 'returns a successful response with HTML' do
        get '/'
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('text/html; charset=utf-8')
        expect(response.body).to include('<html><body style="background-color: green"></body></html>')
      end

      it 'returns a successful response with JSON' do
        get '/', headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to eq({ message: 'OK' }.to_json)
      end
    end

    context 'when the application is down' do
      before(:each) do
        error = StandardError.new('Something went wrong')
        allow(HealthController).to receive(:show).and_raise(error)
      end

      it 'returns an internal server error response with HTML' do
        get '/'
        expect(response).to have_http_status(:internal_server_error)
        expect(response.content_type).to eq('text/html; charset=utf-8')
        expect(response.body).to include('<html><body style="background-color: red"></body></html>')
      end

      it 'returns an internal server error response with JSON' do
        get '/', headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(:internal_server_error)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to eq({ error: 'Something went wrong' }.to_json)
      end
    end
  end
end
