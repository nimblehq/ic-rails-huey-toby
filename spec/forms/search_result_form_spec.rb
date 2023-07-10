# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResultForm, type: :model do
  describe '#valid?' do
    context 'given valid attributes' do
      it 'is valid' do
        user = Fabricate(:user)
        Fabricate.times(5, :search_result, user_id: user.id)

        search_result_form = described_class.new(
          user_id: user.id
        )

        expect(search_result_form).to be_valid
      end
    end

    context 'given NO user_id' do
      it 'is invalid' do
        search_result_form = described_class.new(
          user_id: nil
        )

        expect(search_result_form).not_to be_valid
        expect(search_result_form.errors[:user_id]).to include("can't be blank")
      end
    end
  end

  describe '#paginated_results' do
    context 'given empty params' do
      it 'returns paginated results with default items count' do
        user = Fabricate(:user)
        Fabricate.times(20, :search_result, user_id: user.id)

        search_result_form = described_class.new(
          user_id: user.id
        )

        paginated_results = search_result_form.paginated_results(params: {})

        expect(paginated_results[:results].count).to eq(10)
        expect(paginated_results[:pagy].count).to eq(20)
      end
    end

    context 'given valid params' do
      it 'returns paginated results' do
        user = Fabricate(:user)
        Fabricate.times(20, :search_result, user_id: user.id)

        search_result_form = described_class.new(
          user_id: user.id
        )

        params = {
          page: {
            number: 1,
            size: 5
          }
        }
        paginated_results = search_result_form.paginated_results(params: params)

        expect(paginated_results[:results].count).to eq(5)
        expect(paginated_results[:pagy].count).to eq(20)
      end
    end
  end
end
