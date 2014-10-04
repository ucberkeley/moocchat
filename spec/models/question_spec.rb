require 'spec_helper'

describe Question do
  describe 'new' do
    before :each do
      @q = Question.new :text => 'text', :answers => ['a', '', 'c'], :explanation => 'expl', :correct_answer_index => 1
    end
    specify 'when valid' do
      @q.should be_valid
      @q.should have(2).answers
    end
    specify 'with all blank answers' do
      @q.answers = ['', '']
      @q.should_not be_valid
      @q.should have(1).errors_on(:answers)
    end
    specify 'with empty text' do
      @q.text = ''
      @q. should_not be_valid
      @q.should have(1).errors_on(:text)
    end
    specify 'with correct answer index out of range' do
      @q.correct_answer_index = 2
      @q.should_not be_valid
      @q.errors_on(:correct_answer_index).should include('must be less than or equal to 1')
    end
  end
end
