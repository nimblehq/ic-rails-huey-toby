# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health Endpoint', type: :request do
  describe 'GET #show' do
    context 'given the application is up' do
      it 'returns a successful response with HTML' do
        get '/'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<html><body style="background-color: green"></body></html>')
      end

      it 'returns a successful response with JSON' do
        get '/', headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ message: 'OK' }.to_json)
      end
    end

    context 'given the application is down' do
      it 'returns an internal server error response with HTML' do
        controller_instance = HealthController.new
        allow(HealthController).to receive(:new).and_return(controller_instance)
        allow(controller_instance).to receive(:show).and_raise(StandardError, 'Something went wrong')

        get '/'

        expect(response).to have_http_status(:internal_server_error)
        expect(response.body).to include('<html><body style="background-color: red"></body></html>')
      end

      it 'returns an internal server error response with JSON' do
        controller_instance = HealthController.new
        allow(HealthController).to receive(:new).and_return(controller_instance)
        allow(controller_instance).to receive(:show).and_raise(StandardError, 'Something went wrong')

        get '/', headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:internal_server_error)
        expect(response.body).to eq({ error: 'Something went wrong' }.to_json)
      end
    end
  end
end
