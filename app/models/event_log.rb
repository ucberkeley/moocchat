class EventLog < ActiveRecord::Base

  # When an event is logged, it must have non-nil valid associated models
  # for +Learner+, +ActivitySchema+, +Condition+, +Task+.
  [:learner, :activity_schema, :condition, :task].each do |assoc|
    belongs_to assoc
    attr_accessible assoc
    validates_presence_of assoc
    validates_associated assoc
  end

  # Events MAY be associated with a question, but aren't always.
  belongs_to :question
  attr_accessible :question

  # other event attributes
  attr_accessible :counter, :subcounter, :question_counter, :chat_group
  
  # Only certain event names are valid.
  EVENTS_WITH_VALUES = [
    :user_state,        # user fills in or clicks something (changes user state)
    :chat               # chat utterance
  ]
  EVENTS = [
    :start,     # learner starts an activity
    :form_group, # learner is placed in a group
    :finish,    # learner finishes an activity
    :reject,    # learner cannot be placed in any group, so is kicked out
    :abandon,   # learner detectably abandons task
    :broken_pipe, #  browser crash/close
    :continue,    # learner continues to next page in an activity
    :view_page,   # learner is served a page (including any reloads)
    :quit_chat,  # learner votes to quit chat
    :rejoin_chat # learner reverses vote to quit chat
  ]   

  attr_accessible :name
  validates_inclusion_of :name, :in => EVENTS + EVENTS_WITH_VALUES

  # EVENTS_WITH_VALUES are events that require a nonblank value too.
  attr_accessible :value
  validates_presence_of :value, :if =>
    Proc.new { |e| EVENTS_WITH_VALUES.include?(e.name) }

end
