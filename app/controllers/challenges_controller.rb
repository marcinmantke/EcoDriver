class ChallengesController < ApplicationController
  def create
    route = Trip.find(params[:trip_id])
    finish_date = params[:finish_date].to_date
    if (route.user.id == current_user.id and finish_date > Date.today() and route.challenge == nil)
      challenge = Challenge.create(route: route, finish_date: finish_date)
      route.update(challenge: challenge)
      response = {  success: true,
        data: {
          route: challenge.route,
          finish_date: challenge.finish_date,
          created_by: challenge.route.user.username
        } }
    else
      response = {  success: false, data: {} }
    end

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def all
    challenges = Challenge.all.order(created_at: :desc)
    user_challenges = ChallengesUser.where(user_id: current_user.id)
    challenges_to_show = []
    challenges.each do |challenge|
      is_joined = 0
      user_challenges.each do |user_challenge|
        if challenge.id == user_challenge.id
          is_joined = 1
        end
      end
      challenges_to_show.push(
      {
        id: challenge.id,
        route: challenge.route,
        finish_date: challenge.finish_date,
        created_by: challenge.route.user.username,
        is_joined: is_joined
      })
    end
    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: challenges_to_show }
    end
  end

  def join
    challenge = Challenge.find(params[:challenge_id])
    if challenge != nil
      relation = ChallengesUser.create(user_id: current_user.id, challenge_id: challenge.id)
      response = { success: true }
    else
      response = { success: false }
    end

    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end

  end

  def showPath
    challenge = Challenge.find(params.permit(:id)['id'])
    path = challenge.route.check_points
    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: path }
    end
  end

  def getChallengeTrips
    challenge = Challenge.find(params.permit(:id)['id'])

    conditions = { 'engine_types.eng_type' => params.permit(:engine_type)['engine_type'],
      'engine_displacements.disp' => params.permit(:engine_displacement)['engine_displacement'] }
    conditions.delete_if {|key,val| val.blank? }

    trips = challenge.trips.includes(:engine_type, :engine_displacement)
      .where(conditions)
      .references(:engine_types, :engine_displacements)
      .order(avg_fuel: :asc)
      .group(:user_id)
    path = []
    CheckPoint.where(trip: challenge.route).each do |check_point|
      path.push([])
      path.last.push(check_point['latitude'])
      path.last.push(check_point['longitude'])
    end

    response = {}
    trips_to_render = []
    trips.each do |trip|
      trips_to_render.push({
        distance: trip.distance,
        avg_rpm: trip.avg_rpm ,
        avg_fuel: trip.avg_fuel ,
        avg_speed: trip.avg_speed ,
        date: trip.date.strftime('%F') ,
        user: trip.user.username ,
        engine_displacement: trip.engine_displacement.disp,
        engine_type: trip.engine_type.eng_type,
        mark: trip.mark
        })
    end

    response = {
      trips: trips_to_render,
      path: path
    }

    render json: response
  end

  def getAllUsers
    response = User.select(:username)
    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def inviteUser
    user = User.where(username: params.permit(:user)['user']).first
    if not user.blank?
      user_invitation = Invitation.where(invited_by: current_user, user: user, challenge_id: params.permit(:challenge)['challenge'])

      if user_invitation.blank?
        Invitation.create(invited_by: current_user, user: user, challenge_id: params.permit(:challenge)['challenge'])
        response = {
          success: true,
          msg: 'Invitation has been sent'
        }
      else
        response = {
          success: false,
          msg: 'You already have invited this user.'
        }
      end
    else
      response = {
        success: false,
        msg: 'Wrong username'
      }
    end

    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

end
