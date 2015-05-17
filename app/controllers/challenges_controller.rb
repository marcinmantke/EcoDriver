class ChallengesController < ApplicationController
  include ControllerUtil

  def create
    route = Trip.find(params[:trip_id])
    finish_date = params[:finish_date].to_date
    if check_conditions(route, finish_date)
      challenge = Challenge.create(route: route, finish_date: finish_date)
      response = {  success: true,
                    data: {
                      route: challenge.route,
                      finish_date: challenge.finish_date,
                      created_by: challenge.route.user.username
                    } }
    else
      response = {  success: false, data: {} }
    end

    json_respond_formatter(response)
  end

  def check_conditions(route, finish_date)
    route.user.id == current_user.id &&
      finish_date > Time.zone.today &&
      route.challenge.nil?
  end

  def all
    json_respond_formatter(Challenge.all_for_user(current_user.id))
  end

  def join
    response = { success:
      ChallengesUser.create_unique(current_user.id, params[:challenge_id])
    }
    json_respond_formatter(response)
  end

  def show_path
    challenge = Challenge.find(params.permit(:id)['id'])
    path = challenge.route.check_points
    json_respond_formatter(path)
  end

  def all_challenge_trips
    challenge = Challenge.where(params.permit(:id)).first
    conditions = prepare_condition(params[:engine_type],
                                   params[:engine_displacement])
    json_respond_formatter(trips:
        challenge.trips.all_by_condition(conditions),
                           path:
        path_formater(challenge.route))
  end

  def all_users
    response = User.select(:username)
    json_respond_formatter(response)
  end

  def invite_user
    user = User.where(username: params['user']).first
    success = Invitation.create_unique(
      current_user.id, user.id,
      params['challenge'])
    json_respond_formatter(success)
  end

  def path_formater(trip)
    path = []
    CheckPoint.where(trip: trip).each do |check_point|
      path.push([])
      path.last.push(check_point['latitude'])
      path.last.push(check_point['longitude'])
    end
    path
  end

  def prepare_condition(engine_type, engine_displacement)
    conditions = { 'engine_types.eng_type' => engine_type,
                   'engine_displacements.disp' => engine_displacement }
    conditions.delete_if { |_key, val| val.blank? }
  end

  def all_invitations
    json_respond_formatter current_user.invitations_challenges
  end

  def accept_invitation
    invite = current_user.invitations.find(params[:invitation_id])
    response = { success:
      ChallengesUser.create_unique(current_user.id, invite.challenge_id) }
    invite.destroy! if response[:success]
    json_respond_formatter response
  end

  def reject_invitation
    invite = current_user.invitations.find(params[:invitation_id])
    invite.destroy!
    response = { success: true }
    json_respond_formatter response
  rescue StandardError
    response = { success: false }
    json_respond_formatter response
  end
end
