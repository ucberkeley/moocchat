Given(/^I am at the Questions Page$/) do 
	visit questions_path
end


Given(/^a generated question with explanation "(.*?)"$/) do |arg1|
	@q1= Question.create!(text: "The rate of health complications of patients on intravenous (IV) therapy at a particular hospital was higher than usual. Government inspectors found that the typical IV solutions used in this hospital had somewhat high concentrations of sodium and potassium, which were raising patients' blood pressure and taxing their kidneys. The government inspectors mandated lowering the sodium and potassium in these IV preparations, and threatened with a possible government fine.  In compliance, the hospital lowered the sodium and potassium levels in the IV solutions to the correct levels.  Nevertheless, patients on IV therapy at that hospital continued to have a high rate of health complications. Which of the following, if true, most helps to explain why acting on the government inspectors' recommendations failed to achieve its goal?",answers: ["The change in IV solution procedure meant a number of related legal documents had to be renegotiated and rewritten, at great cost.","When sodium and potassium levels in the blood fall below their baseline level, it can damage cells throughout the body by reverse osmosis.","It is typical for a patient's appetite to increase to healthy levels once they have completed a course of IV therapy.", "A high proportion of patients at this hospital are older, and older patients are more vulnerable to infections that can accompany IVs.", "Because the findings were published in the news, some patients have chosen to use another hospital in the region."],correct_answer_index: 3, explanation: "TO BE DETERMINED")
end

Given(/^I start on the Edit Page for question$/) do 
	visit edit_question_path(@q1)
end



