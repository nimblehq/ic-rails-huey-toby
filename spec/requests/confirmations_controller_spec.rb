# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirmations', type: :request do
  describe 'POST #confirmation' do
    context 'given a correct confirmation_token' do
      it 'navigates to the root path after confirmation' do
        user = Fabricate(:user, confirmed_at: nil, confirmation_token: 'confirmation_token')

        get '/api/v1/users/confirmation', params: { confirmation_token: user.confirmation_token }

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
