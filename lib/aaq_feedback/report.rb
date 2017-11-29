class AaqFeedback::Report
  attr_accessor :date, :positive_feedback, :negative_feedback, :who_supported_student, :student_course, :rating, :regular_comment, :other_positive_comment, :other_negative_comment, :token, :technical_coaches

  attr_reader :num_tokens

  @@tokens = []

  def initialize(token)
    @token = token
    @positive_feedback = []
    @negative_feedback =[]
    @technical_coaches = []
  end

  def self.tokens
    @@tokens
  end

  def self.num_tokens
    @@tokens.count
  end

#--- TAGGING THE SURVEY ---#
  def self.find_and_create_from_survey
    surveys = AaqFeedback::API.new.surveys
    surveys.each do |survey|
      token = self.new(survey["token"])
      token.date = survey["metadata"]["date_submit"]
      token.who_supported_student = survey["answers"]["list_64949235_choice"]
      token.student_course = survey["answers"]["list_66678398_choice"]

      #Technical Coahes attached to the feedback -- need to add the all the technical coaches
      survey["answers"].each do |key, value|
        list_name = "list_64196466_choice_"
        case key
        when list_name + "80218145"
          token.technical_coaches << "Bob"
        when list_name + "80218146"
          token.technical_coaches << "Brian"
        when list_name + "80218147"
          token.technical_coaches << "Dakota"
        when list_name + "80218156"
          token.technical_coaches << "Daniel"
        when list_name + "80218148"
          token.technical_coaches << "Enoch"
        end
      end

      token.rating = survey["answers"]["rating_MIWlzH1BLFWb"].to_i

      #unique comments from students
      token.regular_comment = survey["answers"]["textarea_ummCANBFwJ5i"]
      token.other_positive_comment = survey["answers"]["list_z3PoGEKivPJy_other"]
      token.other_negative_comment = survey["answers"]["list_AOFdoBaHgkUy_other"]

      #feedback response
      survey["answers"]. each do |key, value|
        # positive feedback response
        positive_list_name = "list_z3PoGEKivPJy_choice_"
        negative_list_name = "list_AOFdoBaHgkUy_choice_"

        case key #add a loop?
        when positive_list_name + "w5gBmbDDFw8U"
          token.positive_feedback << "guide me while I debug my code"
        when positive_list_name + "hZUNhYcKu2YU"
          token.positive_feedback << "Boosted my confidence in my coding debugging skills"
        when positive_list_name + "Es8ECIWFTZ7a"
          token.positive_feedback << "I was able to speak to them immediately and have a screenshare quickly"
        when positive_list_name + "DXnkiNkeYsDl"
          token.positive_feedback<< "Explain concepts clearly and concisely"
        # negative feedback response
        when negative_list_name + "poNMdtvx7lHi"
          token.negative_feedback << "Ask me more questions"
        when "list_AOFdoBaHgkUy_choice_oHXicFgyGi2h"
          token.negative_feedback << "Encourage me"
        when negative_list_name + "kNj37gv2WRgU"
          token.negative_feedback<< "Decrease waittime"
        when negative_list_name + "Oqvv5HXi5kyK"
          token.negative_feedback << "Explain concepts clearly and share resources"
        end
      end
      self.tokens << token
    end
  end

  def self.monthly_feedback(month)
    tokens_from_month = []
    self.tokens.select do |token|
      tokens_from_month << token if token.date.include?("2017-#{month}")
    end
    tokens_from_month
  end

  def self.num_monthly_feedback(month)
    monthly_feedback(month).count
  end
  #----- RATINGS ----#
  def self.average_rating(month)
    #REMINDER = need to add date range in this
    ratings = []
    self.monthly_feedback(month).select{|token| ratings << token.rating}
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    puts average
  end

  #-----FEEDBACK-----#

  def self.all_positive_feedback(month)
    all_positive_feedback = []
    self.monthly_feedback(month).select do |token|
      token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
    end

    all_positive_feedback

    @guide_me = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
    @confidence = all_positive_feedback.select{|feedback| feedback == "Boosted my confidence in my coding debugging skills"}.count
    @immediate = all_positive_feedback.select{|feedback| feedback == "I was able to speak to them immediately and have a screenshare quickly"}.count
    @concise_concepts = all_positive_feedback.select{|feedback| feedback == "Explain concepts clearly and concisely"}.count
  end

  def self.frequency_of_positive_feedback(month)
    self.all_positive_feedback(month)

    "Guide me while I debug my code: #{((@guide_me.to_i / num_monthly_feedback(month).to_f)*100).round(2)}% \n Boosted my confidence in my codin/debugging skills: #{((@confidence / num_monthly_feedback(month).to_f)*100).round(2)}% \n I was able to speak to them immediately and have a screenshare quickly: #{((@immediate/num_monthly_feedback(month).to_f)*100).round(2)}% \n Explain concepts clearly and concisely: #{((@concise_concepts / num_monthly_feedback(month).to_f)*100).round(2)}%"
  end

  def self.all_negative_feedback(month)
    all_negative_feedback = []
    self.monthly_feedback(month).select do |token|
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
    self.tokens.select do |token|
      technical_coach_feedback << token if token.technical_coaches.include?(technical_coach)
    end

    technical_coach_feedback.select do |token|
      tokens_from_month << token if token.date.include?("2017-#{month}")
    end

    tokens_from_month.select{|token| ratings << token.rating}
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    average
  end


end
