Given(/^I am at the Questions Page$/) do 
	visit questions_path
end


Given(/^a generated question with explanation "(.*?)"$/) do |arg1|
	@q1= Question.create!(text: "1",answers: ["The change in IV solution procedure meant a number of related legal documents had to be renegotiated and rewritten, at great cost.","When sodium and potassium levels in the blood fall below their baseline level, it can damage cells throughout the body by reverse osmosis.","It is typical for a patient's appetite to increase to healthy levels once they have completed a course of IV therapy.", "A high proportion of patients at this hospital are older, and older patients are more vulnerable to infections that can accompany IVs.", "Because the findings were published in the news, some patients have chosen to use another hospital in the region."],correct_answer_index: 3, explanation:arg1)
end

Given(/^I start on the Edit Page$/) do
	visit edit_question_path(@q1)
end

Given(/^I start on the Edit Page for "(.*)"$/) do |page|
  edit_question_path(Questions.find_by_name(page))
end
