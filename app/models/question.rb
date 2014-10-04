class Question < ActiveRecord::Base
  has_many :event_logs
  serialize :answers, Array
  attr_accessible  :answers, :text,:correct_answer_index, :explanation

  before_validation { self.answers.reject!(&:blank?) }

  validates_presence_of :text
  validates_presence_of :answers
  validate :correct_answer_index_in_range

  protected

  def correct_answer_index_in_range
    return if answers.empty?    # another validation will catch this
    errors.add(:correct_answer_index, 'must be greater than or equal to 0') unless
      correct_answer_index >= 0
    num_answers = answers.size
    errors.add(:correct_answer_index, "must be less than or equal to #{num_answers-1}") unless
      correct_answer_index <= num_answers - 1
    false
  end

end
