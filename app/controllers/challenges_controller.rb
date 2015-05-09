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
    challenges_to_show = []
    challenges.each do |challenge|
      challenges_to_show.push(
      {
        route: challenge.route,
        finish_date: challenge.finish_date,
        created_by: challenge.route.user.username
      })
    end
    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: challenges_to_show }
    end
  end
end
