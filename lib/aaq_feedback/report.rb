class AaqFeedback::Report

  def monthly_feedback(month)
    # binding.pry
    tokens_from_month = []
    AaqFeedback::Token.tokens.select do |token|
      tokens_from_month << token if token.date.include?("2017-#{month}")
    end
    tokens_from_month
  end

  def self.num_monthly_feedback(month)
    self.new.monthly_feedback(month).count
  end
  #----- RATINGS ----#
  def self.average_rating(month)
    #REMINDER = need to add date range in this
    ratings = []
    self.new.monthly_feedback(month).select{|token| ratings << token.rating}
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    average.round(2)
  end

  #-----FEEDBACK-----#

  def self.all_positive_feedback(month)
    all_positive_feedback = []
    self.new.monthly_feedback(month).select do |token|
      token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
    end

    all_positive_feedback

    @guide_me = all_positive_feedback.select{|feedback| feedback.include?("Guide me")}.count
    @confidence = all_positive_feedback.select{|feedback| feedback.include?("confidence")}.count
    @immediate = all_positive_feedback.select{|feedback| feedback.include?("immediately")}.count
    @concise_concepts = all_positive_feedback.select{|feedback| feedback.include?("Explain concepts")}.count
  end

  def self.frequency_of_positive_feedback(month)
    self.all_positive_feedback(month)

    "Guide me while I debug my code: #{((@guide_me.to_i / num_monthly_feedback(month).to_f)*100).round(2)}% \n Boosted my confidence in my codin/debugging skills: #{((@confidence / num_monthly_feedback(month).to_f)*100).round(2)}% \n I was able to speak to them immediately and have a screenshare quickly: #{((@immediate/num_monthly_feedback(month).to_f)*100).round(2)}% \n Explain concepts clearly and concisely: #{((@concise_concepts / num_monthly_feedback(month).to_f)*100).round(2)}%"
  end

  def self.all_negative_feedback(month)
    all_negative_feedback = []
    self.new.monthly_feedback(month).select do |token|
      token.negative_feedback.each{|feedback| all_negative_feedback << feedback}
    end

    all_negative_feedback

    @ask_more = all_negative_feedback.select{|feedback| feedback == "Ask me more questions"}.count
    @encourage_me = all_negative_feedback.select{|feedback| feedback == "Encourage me"}.count
    @decrease_waittime = all_negative_feedback.select{|feedback| feedback == "Decrease waittime"}.count
    @explain_concepts = all_negative_feedback.select{|feedback| feedback == "Explain concepts clearly and share resources"}.count
  end

  def self.frequency_of_negative_feedback(month)
    self.all_negative_feedback(month)

    "Ask me more questions: #{((@ask_more/num_monthly_feedback(month).to_f)*100).round(2)}% \n Encourage me: #{((@encourage_me / num_monthly_feedback(month).to_f)*100).round(2)}% \n Decrease waittime: #{((@decrease_waittime/num_monthly_feedback(month).to_f)*100).round(2)}% \n Explain concepts clearly and share resources: #{((@explain_concepts / num_monthly_feedback(month).to_f)*100).round(2)}%"
  end

  #----FOR TECHNICAL COACHES----#
  def self.technical_coach_average_rating(month, technical_coach)
    #REMINDER = need to add date range in this
    technical_coach_feedback = []
    tokens_from_month = []
    ratings = []
    AaqFeedback::Token.tokens.select do |token|
      technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
    end

    technical_coach_feedback.select do |token|
      tokens_from_month << token if token.date.include?("2017-#{month}")
    end

    tokens_from_month.select{|token| ratings << token.rating}
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    average.round(2)
  end


end
