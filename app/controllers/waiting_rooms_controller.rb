class WaitingRoomsController < ApplicationController

  skip_before_filter :require_authenticated_user, :only =>
    [:group_formation_times, :seconds_to_next_group_formation]

  def group_formation_times
    waiting_room = WaitingRoom.where(
      ['condition_id = ? AND activity_schema_id = ?',
        params[:condition_id], params[:activity_schema_id]]).first
    render :json => waiting_room.to_json
  end

  def seconds_to_next_group_formation  
    # Do not require request.xhr? because it blocks JSONP
    activity_schema = ActivitySchema.find params[:activity_schema_id]
    render :json => {seconds_to_next_group_formation: (activity_schema.compute_expiration_time - Time.zone.now).to_i}.to_json, :callback => params['callback']
  end

end
