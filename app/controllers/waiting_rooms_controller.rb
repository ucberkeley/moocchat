class WaitingRoomsController < ApplicationController

  def group_formation_times
    waiting_room = WaitingRoom.where(
      ['condition_id = ? AND activity_schema_id = ?',
        params[:condition_id], params[:activity_schema_id]]).first
    render :json => waiting_room.to_json
  end

end
