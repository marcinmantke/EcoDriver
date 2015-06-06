require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      let!(:login) { login_user }
      let(:current_user_id) { login.id }
      it 'create challenge' do
        FactoryGirl.create(:full_trip, user_id: current_user_id)
        post :create, challenge: attributes_for(:challenge), format: :json
        expect(Challenge.count).to eq(1)
      end
      it 'without start/finish params create challenge with whole path' do
        FactoryGirl.create(:full_trip, user_id: current_user_id)
        FactoryGirl.create_list(:check_point, 10)
        post :create,
             challenge: { trip_id: 2, finish_date: Time.zone.tomorrow },
             format: :json
        expect(Challenge.last.finish_point)
          .to eq(Trip.last.check_points.count - 1)
      end
      it 'without start finish params create challenge with part of path' do
        FactoryGirl.create(:full_trip, user_id: current_user_id)
        FactoryGirl.create_list(:check_point, 10)
        post :create,
             challenge: attributes_for(:challenge, trip_id: 3),
             format: :json
        expect(Challenge.last.finish_point).to eq(4)
        expect(Challenge.last.start_point).to eq(2)
      end
    end
  end
end
