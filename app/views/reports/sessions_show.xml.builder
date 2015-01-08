xml.instruct!
xml.sessions do
  @sessions.each do |session|
    xml.session do
      xml.chat_group session[:chat_group]
      xml.group_size session[:group_size]
      xml.question_id session[:question_id]
      xml.correct_choice session[:correct_choice]
      xml.start_time_0 session[:start_time_0]
      xml.start_time_1 session[:start_time_1]
      xml.start_time_2 session[:start_time_2]
      xml.initial_choice_0 session[:initial_choice_0]
      xml.initial_choice_1 session[:initial_choice_1]
      xml.initial_choice_2 session[:initial_choice_2]
      xml.final_choice_0 session[:final_choice_0]
      xml.final_choice_1 session[:final_choice_1]
      xml.final_choice_2 session[:final_choice_2]
    end
  end
end
