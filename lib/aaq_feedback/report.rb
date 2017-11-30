class AaqFeedback::Report
  attr_reader :technical_coach_feedback
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
  def self.average_rating(month, technical_coach = nil)
    #REMINDER = need to add date range in this
    ratings = []
    tokens_from_month = []
    technical_coach_feedback = []
    if technical_coach.nil?
      self.new.monthly_feedback(month).select{|token| ratings << token.rating}
    else
      AaqFeedback::Token.tokens.select do |token|
        technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
      end
      technical_coach_feedback.select do |token|
        tokens_from_month << token if token.date.include?("2017-#{month}")
        tokens_from_month.select{|token| ratings << token.rating}
      end
    end
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    average.round(2)
  end

  #-----FEEDBACK-----#

  def self.all_positive_feedback(month, technical_coach = nil)
    all_positive_feedback = []
    tokens_from_month = []
    technical_coach_feedback = []
    if !technical_coach == nil
      AaqFeedback::Token.tokens.select do |token|
        technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
      end
      technical_coach_feedback.select do |token|
        tokens_from_month << token if token.date.include?("2017-#{month}")
      end
      tokens_from_month.select do |token|
        token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
      end
    else
      self.new.monthly_feedback(month).select do |token|
        token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
      end
    end

    all_positive_feedback

    @guide_me = all_positive_feedback.select{|feedback| feedback.include?("Guide me")}.count
    @confidence = all_positive_feedback.select{|feedback| feedback.include?("confidence")}.count
    @immediate = all_positive_feedback.select{|feedback| feedback.include?("immediately")}.count
    @concise_concepts = all_positive_feedback.select{|feedback| feedback.include?("Explain concepts")}.count
  end

  def self.frequency_of_positive_feedback(month,technical_coach = nil)
    self.all_positive_feedback(month, technical_coach = nil)

    "Guide me while I debug my code: #{((@guide_me.to_i / num_monthly_feedback(month).to_f)*100).round(2)}% \n Boosted my confidence in my codin/debugging skills: #{((@confidence / num_monthly_feedback(month).to_f)*100).round(2)}% \n I was able to speak to them immediately and have a screenshare quickly: #{((@immediate/num_monthly_feedback(month).to_f)*100).round(2)}% \n Explain concepts clearly and concisely: #{((@concise_concepts / num_monthly_feedback(month).to_f)*100).round(2)}%"
  end

  def self.all_negative_feedback(month, technical_coach = nil)
    all_negative_feedback = []
    tokens_from_month = []
    technical_coach_feedback = []

    if technical_coach == nil
      self.new.monthly_feedback(month).select do |token|
        token.negative_feedback.each{|feedback| all_negative_feedback << feedback}
      end
    else
      AaqFeedback::Token.tokens.select do |token|
        technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
      end
      technical_coach_feedback.select do |token|
        if token.date.include?("2017-#{month}")
          token.negative_feedback.each{|feedback| all_negative_feedback << feedback}
        end
      end
    end
    all_negative_feedback

    @ask_more = all_negative_feedback.select{|feedback| feedback == "Ask me more questions"}.count
    @encourage_me = all_negative_feedback.select{|feedback| feedback == "Encourage me"}.count
    @decrease_waittime = all_negative_feedback.select{|feedback| feedback == "Decrease waittime"}.count
    @explain_concepts = all_negative_feedback.select{|feedback| feedback == "Explain concepts clearly and share resources"}.count
  end

  def self.frequency_of_negative_feedback(month, technical_coach = nil)
    self.all_negative_feedback(month, technical_coach = nil)

    "Ask me more questions: #{((@ask_more/num_monthly_feedback(month).to_f)*100).round(2)}% \n Encourage me: #{((@encourage_me / num_monthly_feedback(month).to_f)*100).round(2)}% \n Decrease waittime: #{((@decrease_waittime/num_monthly_feedback(month).to_f)*100).round(2)}% \n Explain concepts clearly and share resources: #{((@explain_concepts / num_monthly_feedback(month).to_f)*100).round(2)}%"
  end

  def self.other_feedback(month, technical_coach)
    technical_coach_feedback = []
    all_negative_feedback = []
    tokens_from_month = []
    AaqFeedback::Token.tokens.select do |token|
      if token.technical_coaches.include?(technical_coach)
        if token.date.include?("2017-#{month}")
          technical_coach_feedback << token.other_positive_comment
          technical_coach_feedback << token.other_negative_comment
        end
      end
    end

    technical_coach_feedback.each do |comment|
       comment
    end

  end

#!----- TEST OUT DELETE SOON -----!#

  def self.all_positive_feedback_tc(month, technical_coach)
    all_positive_feedback = []
    tokens_from_month = []
    @technical_coach_feedback = []
      AaqFeedback::Token.tokens.select do |token|
        @technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
      end
      @technical_coach_feedback.select do |token|
        tokens_from_month << token if token.date.include?("2017-#{month}")
      end
      tokens_from_month.select do |token|
        token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
      end

    all_positive_feedback

    @guide_me = all_positive_feedback.select{|feedback| feedback.include?("Guide me")}.count
    @confidence = all_positive_feedback.select{|feedback| feedback.include?("confidence")}.count
    @immediate = all_positive_feedback.select{|feedback| feedback.include?("immediately")}.count
    @concise_concepts = all_positive_feedback.select{|feedback| feedback.include?("Explain concepts")}.count
  end

  def self.frequency_of_positive_feedback_tc(month,technical_coach)

    self.all_positive_feedback_tc(month, technical_coach)

    "Guide me while I debug my code: #{((@guide_me.to_i / @technical_coach_feedback.count.to_f)*100).round(2)}% \n Boosted my confidence in my codin/debugging skills: #{((@confidence / @technical_coach_feedback.count.to_f)*100).round(2)}% \n I was able to speak to them immediately and have a screenshare quickly: #{((@immediate/@technical_coach_feedback.count.to_f)*100).round(2)}% \n Explain concepts clearly and concisely: #{((@concise_concepts / @technical_coach_feedback.count.to_f)*100).round(2)}%"
  end

  def self.all_negative_feedback_tc(month, technical_coach)
    all_negative_feedback = []
    tokens_from_month = []
    @technical_coach_feedback = []
      AaqFeedback::Token.tokens.select do |token|
        @technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
      end
      @technical_coach_feedback.select do |token|
        if token.date.include?("2017-#{month}")
          token.negative_feedback.each{|feedback| all_negative_feedback << feedback}
        end
      end
    all_negative_feedback

    @ask_more = all_negative_feedback.select{|feedback| feedback == "Ask me more questions"}.count
    @encourage_me = all_negative_feedback.select{|feedback| feedback == "Encourage me"}.count
    @decrease_waittime = all_negative_feedback.select{|feedback| feedback == "Decrease waittime"}.count
    @explain_concepts = all_negative_feedback.select{|feedback| feedback == "Explain concepts clearly and share resources"}.count
  end

  def self.frequency_of_negative_feedback_tc(month, technical_coach)
    self.all_negative_feedback_tc(month, technical_coach)

    "Ask me more questions: #{((@ask_more/@technical_coach_feedback.count.to_f)*100).round(2)}% \n Encourage me: #{((@encourage_me / @technical_coach_feedback.count.to_f)*100).round(2)}% \n Decrease waittime: #{((@decrease_waittime/@technical_coach_feedback.count.to_f)*100).round(2)}% \n Explain concepts clearly and share resources: #{((@explain_concepts / @technical_coach_feedback.count.to_f)*100).round(2)}%"
  end





end
