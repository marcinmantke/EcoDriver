require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the trip' do
        login_user
        post :create, trip: attributes_for(:trip_with_path), format: :json
        expect(Trip.count).to eq(1)
      end
      it 'renders cretead trip as json' do
        login_user
        post :create, trip: attributes_for(:trip_with_path), format: :json
        expect(response.body)
          .to eq(({ data: build(:trip,
                                id: 2,
                                user_id: 2,
                                engine_type_id: 1,
                                engine_displacement_id: 1,
                                finish: 'Atlantic Ocean',
                                beginning: 'Atlantic Ocean'),
                    success: true }).to_json)
      end
    end
    context 'with nil avg_speed' do
      it 'doesn\'t create the trip' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_speed: nil),
             format: :json
        expect(Trip.count).to eq(0)
      end
      it 'render json with \"success: false\"' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_speed: nil),
             format: :json
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end
    context 'with nil avg_rpm' do
      it 'doesn\'t create the trip' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_rpm: nil),
             format: :json
        expect(Trip.count).to eq(0)
      end
      it 'render json with \"success: false\"' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_rpm: nil),
             format: :json
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end
    context 'with nil avg_fuel' do
      it 'doesn\'t create the trip' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_fuel: nil),
             format: :json
        expect(Trip.count).to eq(0)
      end
      it 'render json with \"success: false\"' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, avg_fuel: nil),
             format: :json
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end
    context 'with nil distance' do
      it 'doesn\'t create the trip' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, distance: nil),
             format: :json
        expect(Trip.count).to eq(0)
      end
      it 'render json with \"success: false\"' do
        login_user
        post :create,
             trip: attributes_for(:trip_with_path, distance: nil),
             format: :json
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end
  end

  describe 'GET #mytrips' do
    context 'with valid attributes' do
      it 'renders all user\'s trips as json' do
        login_user
        # FactoryGirl.create(:full_trip)
        get :mytrips, format: :json
        expect(response).to be_success
        # json = JSON.parse(response.body)
        # expect(json.length).to eq(15)
      end
    end
  end
end
