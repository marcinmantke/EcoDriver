require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'create challenge' do
        login_user
        FactoryGirl.create(:full_trip)
        post :create, challenge: attributes_for(:challenge), format: :json
        expect(Challenge.count).to eq(1)
      end
    end
  end
end
