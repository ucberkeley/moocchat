class Task < ActiveRecord::Base

  class Sequencer
    # Provides sequencing logic for a +Condition+.
    # Automatically initialized as part of a +Task+, and used by
    # +TaskController+ to sequence the pages.

    # Returns one of +:in_prologue+, +:in_body+, or +:in_epilogue+ indicating
    # where we are in the sequence
    attr_reader :where

    # Current value of monotonically increasing sequence counter, which
    # starts from 0
    attr_reader :counter

    # Current position within prologue, body, or epilogue (starts at 0)
    attr_reader :subcounter

    def initialize(body_reps=0)     # :nodoc:
      @body_reps = body_reps
      @counter = @subcounter = 0
      @where = :in_prologue
    end

    public

    # Return +Template+ object to be rendered next for +condition+,
    # or +nil+ if end of sequence.  (The task's +condition+ must be
    # passed in so we don't have to serialize it to the database.)
    def current_page(condition=nil)
      @condition ||= condition
      array = array_for_current_subsequence
      # boundary condition: zero body iterations
      unless (@where == :in_body && @body_reps.zero?)
        if (elt = array[@subcounter])
          return elt
        end
      end
      # end of subsequence reached: if in body, iterate again
      if @where == :in_body && @body_reps > 1
        start_new_body_iteration
        return current_page
      end
      # end of subsequence reached: try next subsequence
      @where = next_subsequence
      # if we are all out of subsequences, this is the end of the flow
      return nil if @where.nil?
      # else we still have a subsequence to try, so reset subsequence counter,
      # and tail-recurse
      @subcounter = 0
      return current_page
    end

    # Advance to next page.
    def next_page
      @subcounter += 1
      @counter += 1
    end

    private

    def start_new_body_iteration
      @body_reps -= 1
      @subcounter = 0
    end

    def array_for_current_subsequence
      case @where
      when :in_prologue then @condition.prologue
      when :in_body then @condition.body
      when :in_epilogue then @condition.epilogue
      else raise RuntimeError, "Unknown sequence state #{@where}"
      end
    end

    def next_subsequence
      case @where
      when :in_prologue then :in_body
      when :in_body then :in_epilogue
      when :in_epilogue then nil
      else raise RuntimeError, "Unknown sequence state #{@where}"
      end
    end
  end

end
