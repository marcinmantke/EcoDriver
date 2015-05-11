class ChallengesController < ApplicationController
  def create
    route = Trip.find(params[:trip_id])
    finish_date = params[:finish_date].to_date
    if (route.user.id == current_user.id and finish_date > Date.today() and route.challenge == nil)
      challenge = Challenge.create(route: route, finish_date: finish_date)
      route.update(challenge: challenge)
      response = {  :success => true,
        :data => {
          route: challenge.route,
          finish_date: challenge.finish_date,
          created_by: challenge.route.user.username
        }}
    else
      response = {  :success => false, :data => {} }
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
        response = { :success => true }
    else
      response = { :success => false }
    end

    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end

  end
end
