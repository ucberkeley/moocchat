class Task < ActiveRecord::Base

  class Sequencer
    attr_accessor :where, :counter, :subcounter, :body_reps
    def initialize(body_reps=0)
      @body_reps = body_reps
      @counter = @subcounter = 0
      @where = :in_prologue
    end
    def current_page(condition=nil)
      @condition ||= condition
      array = array_for_current_subsequence
      # boundary condition: zero body iterations
      unless (where == :in_body && body_reps.zero?)
        if (elt = array[subcounter])
          return elt
        end
      end
      # end of subsequence reached: if in body, iterate again
      if where == :in_body && body_reps > 1
        start_new_body_iteration
        return current_page
      end
      # end of subsequence reached: try next subsequence
      self.where = next_subsequence
      # if we are all out of subsequences, this is the end of the flow
      return nil if where.nil?
      # else we still have a subsequence to try, so reset subsequence counter,
      # and tail-recurse
      self.subcounter = 0
      return current_page
    end

    def next_page
      self.subcounter += 1
      self.counter += 1
    end

    private

    def start_new_body_iteration
      self.body_reps -= 1
      self.subcounter = 0
    end

    def array_for_current_subsequence
      case where
      when :in_prologue then @condition.prologue
      when :in_body then @condition.body
      when :in_epilogue then @condition.epilogue
      else raise RuntimeError, "Unknown sequence state #{sequence_state.where}"
      end
    end

    def next_subsequence
      case where
      when :in_prologue then :in_body
      when :in_body then :in_epilogue
      when :in_epilogue then nil
      else raise RuntimeError, "Unknown sequence state #{sequence_state.where}"
      end
    end
  end

end
