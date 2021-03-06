require 'rails_helper'
require 'net/http'

RSpec.describe TripsController, :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'tests google api' do
        url = 'https://roads.googleapis.com/v1/snapToRoads?' \
        'path=-35.28302,149.12881|-35.28473,149.12836' \
        '&key=AIzaSyDRljTMN1vNOQL2zxIMh93xA2yni1akkqU'
        encoded_url = URI.encode(url)
        parsed_url = URI.parse(encoded_url)
        http = Net::HTTP.new(parsed_url.host, parsed_url.port)
        http.use_ssl = true
        result = http.get(parsed_url.request_uri)
        res_temp = ActiveSupport::JSON.decode(result.body)['snappedPoints']
        expect(res_temp.length).to eq(2)
      end
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
                                id: 5,
                                user_id: 5,
                                engine_type_id: 1,
                                engine_displacement_id: 1,
                                beginning: 'Australia,' \
                                ' Australian Capital Territory,' \
                                ' Canberra, City, Vernon Cir',
                                finish: 'Australia, New South Wales, 23'),
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
    context 'with challenge_id' do
      it 'create ChallengeUser record' do
        login_user
        post :create, trip: attributes_for(:trip_with_challenge), format: :json
        expect(ChallengesUser.count).to eq(1)
      end
      it 'create only one ChallengeUser record' do
        login_user
        post :create, trip: attributes_for(:trip_with_challenge), format: :json
        post :create, trip: attributes_for(:trip_with_challenge), format: :json
        expect(ChallengesUser.count).to eq(1)
      end
    end
  end

  describe 'GET #mytrips' do
    context 'with valid attributes' do
      let!(:login) { login_user }
      let(:current_user_id) { login.id }
      it 'renders all user\'s trips as json' do
        FactoryGirl.create(:engine_displacement)
        FactoryGirl.create(:engine_type)
        FactoryGirl.create(:fuel_consumption)
        FactoryGirl.create(:full_trip, user_id: current_user_id)
        get :mytrips, format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json[0].length).to eq(20)
      end
      it 'renders empty array when user has no trips' do
        get :mytrips, format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json).to be_empty
      end
    end
    context 'with user not logged in' do
      it 'redirects to login page' do
        FactoryGirl.create(:engine_displacement)
        FactoryGirl.create(:engine_type)
        FactoryGirl.create(:full_trip)
        get :mytrips, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end
end
