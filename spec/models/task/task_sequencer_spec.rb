require 'spec_helper'

describe Task::Sequencer do
  describe 'initializing' do
    subject { Task::Sequencer.new(3) }
    its(:counter) { should == 1 }
    its(:where)   { should == :in_prologue }
    its(:subcounter) { should == 0 }
  end
  # each test case gives prologue, body, epilogue, body iteration count, and expected result
  describe 'sequences pages when no question advance' do
    TEST_CASES = {
      # no nonempty arrays, nonzero body iterations
      [ %w(a), %w(b c), %w(d), 2] =>  %w(a b c b c d),
      [ %w(a b), %w(c), %w(e f), 1] => %w(a b c e f),
      # some empty arrays, nonzero body iterations
      [ [], %w(a b), [], 2] => %w(a b a b),
      # zero body iterations
      [ %w(a), %w(b c), %w(d e), 0] => %w(a d e),
    }
    TEST_CASES.each_pair do |test, result|
      specify test do
        condition = mock_model(Condition,
          :prologue_pages => test[0], :body_pages => test[1], :epilogue_pages => test[2])
        sequencer = Task::Sequencer.new(test[3])
        test_result = []
        while (next_elt = sequencer.current_page(condition))
          test_result << next_elt
          sequencer.next_page
        end
        test_result.should == result
      end
    end
  end
  describe 'sequences pages when question advances' do
    {
      # 'q' is a page that advances the 0-based question counter
      [ %w(p), %w(q1 b q2), %w(e), 4 ] => %w(p q1 b q2 q1 b q2 e),
    }.each_pair do |test_case, result|
      specify test_case do
        prologue, body, epilogue, num_questions = test_case
        condition = mock_model(Condition,
          :prologue_pages => prologue, :body_pages => body, :epilogue_pages => epilogue)
        sequencer = Task::Sequencer.new(num_questions)
        test_result = []
        while (next_elt = sequencer.current_page(condition))
          test_result << next_elt
          sequencer.next_page
          sequencer.next_question if next_elt =~ /^q/
        end
        test_result.should == result
      end
    end
  end
  it 'remains nil when done' do
    condition = mock_model(Condition,
      :prologue_pages => [], :body_pages => %w(a b), :epilogue_pages => [])
    sequencer = Task::Sequencer.new(1)
    sequencer.current_page(condition).should == 'a'
    sequencer.next_page
    sequencer.current_page.should == 'b'
    sequencer.next_page
    sequencer.current_page.should be_nil
    sequencer.current_page.should be_nil
  end    
end
