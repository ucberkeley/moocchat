require 'spec_helper'

describe Task do

  describe 'creating from POST params' do
    context 'when learner does not exist' do
      before :each do
        @condition = mock_model(Condition, :valid? => true)
        @activity_schema = mock_model(ActivitySchema, :valid? => true)
        @args = {
          :condition_id => @condition.id,
          :activity_schema_id => @activity_schema.id,
          :learner_name => 'joe'
        }
        Condition.stub(:find).and_return(@condition)
        ActivitySchema.stub(:find).and_return(@activity_schema)
      end
      it 'creates new learner' do
        expect { Task.create_from_params @args }.to change { Learner.count }.by(1)
      end
      it 'creates valid task' 
      context 'when learner already exists' do
        it 'does not create new learner'
        it 'creates valid task'
      end
    end
  end

end
