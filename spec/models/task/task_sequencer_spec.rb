require 'spec_helper'

describe Task::Sequencer do
  describe 'initializing' do
    subject { Task::Sequencer.new(:body_repeat_count => 3, :num_questions => 3) }
    its(:counter) { should == 1 }
    its(:where)   { should == :in_prologue }
    its(:subcounter) { should == 0 }
  end
  # each test case gives prologue, body, epilogue, body iteration count, and expected result
  shared_examples 'sequences pages' do |test_cases|
    test_cases.each_pair do |test_case, result|
      specify test_case do
        prologue, body, epilogue, num_repeats, num_questions = test_case
        condition = mock_model(Condition,
          :prologue_pages => prologue, :body_pages => body, :epilogue_pages => epilogue)
        sequencer = Task::Sequencer.new(:body_repeat_count => num_repeats, :num_questions => num_questions)
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
  describe 'when no question advance' do
    cases = {
      # prologue, body, epilogue, body repeat count, #q's in activity-schema
      [ %w(a), %w(b c), %w(d), 2, 2]   =>  %w(a b c b c d),
      [ %w(a b), %w(c), %w(e f), 1, 1] => %w(a b c e f),
      [ [], %w(a b), [], 2, 2]         => %w(a b a b),
    }
    it_should_behave_like 'sequences pages', cases
  end
  describe 'when question advances' do
    cases = {
      # 'q' is a page that advances the 0-based question counter
      [ %w(p), %w(q1 b q2), %w(e), 2, 4  ] => %w(p q1 b q2 q1 b q2 e),
    }
    it_should_behave_like 'sequences pages', cases
  end
  it 'remains nil when done' do
    condition = mock_model(Condition,
      :prologue_pages => [], :body_pages => %w(a b), :epilogue_pages => [])
    sequencer = Task::Sequencer.new(:body_repeat_count => 1, :num_questions => 1)
    sequencer.current_page(condition).should == 'a'
    sequencer.next_page
    sequencer.current_page.should == 'b'
    sequencer.next_page
    sequencer.current_page.should be_nil
    sequencer.current_page.should be_nil
  end
end
