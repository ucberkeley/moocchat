require 'spec_helper'
describe WaitingRoomsController do
  describe 'retrieving waiting room times' do
    before :each do
      @expire_time = 10.minutes.from_now
      condition = create :condition
      activity_schema = create :activity_schema, :starts_every => 30
      waiting_room = create :waiting_room, :condition => condition, :activity_schema => activity_schema, :expires_at => @expire_time
      get :group_formation_times, :condition_id => condition, :activity_schema_id => activity_schema
      @response = JSON(response.body)
    end
    it 'has correct expiration time' do
      @response['expires_at'].to_datetime.to_s(:db).should ==
        @expire_time.to_s(:db)
    end
  end
end
