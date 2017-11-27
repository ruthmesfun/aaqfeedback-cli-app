class AaqFeedback::Report
  attr_accessor :date, :positive_feedback, :negative_feedback, :who_supported_student, :student_course, :rating, :regular_comment, :other_positive_comment, :other_negative_comment, :token

  attr_reader :num_tokens

  @@tokens = []

  def initialize(token)
    @token = token
    @positive_feedback = []
    @negative_feedback =[]
  end

  def self.tokens
    @@tokens
  end

  def self.num_tokens
    @@tokens.count
  end

  def self.find_and_create_from_survey
    surveys = AaqFeedback::API.new.surveys
    surveys.each do |survey|
      token = self.new(survey["token"])
      token.date = survey["metadata"]["date_submit"]
      token.who_supported_student = survey["answers"]["list_64949235_choice"]
      token.student_course = survey["answers"]["list_66678398_choice"]
      #! @technical_coach = survey["answers"][/^list_64196466/] << I want this to show the technical coach name
      token.rating = survey["answers"]["rating_MIWlzH1BLFWb"].to_i

      #unique comments from students
      token.regular_comment = survey["answers"]["textarea_ummCANBFwJ5i"]
      token.other_positive_comment = survey["answers"]["list_z3PoGEKivPJy_other"]
      token.other_negative_comment = survey["answers"]["list_AOFdoBaHgkUy_other"]

      #feedback response
      survey["answers"]. each do |key, value|
        #positive feedback response
        if key == "list_z3PoGEKivPJy_choice_w5gBmbDDFw8U"
          token.positive_feedback << "guide me while I debug my code"
        elsif key == "list_z3PoGEKivPJy_choice_hZUNhYcKu2YU"
          token.positive_feedback << "Boosted my confidence in my coding debugging skills"
        elsif key == "list_z3PoGEKivPJy_choice_Es8ECIWFTZ7a"
          token.positive_feedback << "I was able to speak to them immediately and have a screenshare quickly"
        elsif key == "list_z3PoGEKivPJy_choice_DXnkiNkeYsDl"
          token.positive_feedback<< "Explain concepts clearly and concisely"
        #negative feedback response
        elsif key == "list_AOFdoBaHgkUy_choice_poNMdtvx7lHi"
          token.negative_feedback << "Ask me more questions"
        elsif key == "list_AOFdoBaHgkUy_choice_oHXicFgyGi2h"
          token.negative_feedback << "Encourage me"
        elsif key == "list_AOFdoBaHgkUy_choice_kNj37gv2WRgU"
          token.negative_feedback<< "Decrease waittime"
        elsif key == "list_AOFdoBaHgkUy_choice_Oqvv5HXi5kyK"
          token.negative_feedback << "Explain concepts clearly and share resources"
        end
      end
      self.tokens << token
    end
  end

  def self.average_rating
    #REMINDER = need to add date range in this
    ratings = []
    self.tokens.select{|token| ratings << token.rating}
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
    puts average
  end

  def self.all_positive_feedback
    all_positive_feedback = []
    self.tokens.select do |token|
      token.positive_feedback.each{|feedback| all_positive_feedback << feedback}
    end
    all_positive_feedback
    @guide_me = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
    @confidence = all_positive_feedback.select{|feedback| feedback == "Boosted my confidence in my coding debugging skills"}.count
    @immediate = all_positive_feedback.select{|feedback| feedback == "I was able to speak to them immediately and have a screenshare quickly"}.count
    @concise_concepts = all_positive_feedback.select{|feedback| feedback == "Explain concepts clearly and concisely"}.count
  end

  def self.frequency_of_positive_feedback
    self.all_positive_feedback

    "Guide me while I debug my code: #{(@guide_me.to_i / num_tokens.to_f)*100}% \n Boosted my confidence in my codin/debugging skills: #{(@confidence / num_tokens.to_f)*100}% \n I was able to speak to them immediately and have a screenshare quickly: #{(@immediate/num_tokens.to_f)*100}% \n Explain concepts clearly and concisely: #{(@concise_concepts / num_tokens.to_f)*100}%"
  end

  def self.all_negative_feedback
    all_negative_feedback = []
    self.tokens.select do |token|
      token.negative_feedback.each{|feedback| all_negative_feedback << feedback}
    end
    all_negative_feedback
    binding.pry
    # @pos1 = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
    # pos2 = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
    # pos3 = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
    # pos4 = all_positive_feedback.select{|feedback| feedback == "guide me while I debug my code"}.count
  end

end

# {"token"=>"9676fcf15120e3b26a663fd9b271b1c0", "completed"=>"1", "metadata"=>{"browser"=>"default", "platform"=>"other", "date_land"=>"2017-11-22 20:22:35", "date_submit"=>"2017-11-22 20:27:37", "user_agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36", "referer"=>"https://theflatironschool.typeform.com/to/TW4DdU", "network_id"=>"f269724f24"}, "hidden"=>[], "answers"=>{"list_66678398_choice"=>"Full Stack Web Development", "list_64949235_choice"=>"Technical Coach", "list_64196466_choice_82327381"=>"Benton", "rating_MIWlzH1BLFWb"=>"2", "list_z3PoGEKivPJy_choice_Es8ECIWFTZ7a"=>"I was able to speak to them immediately and have a screenshare quickly", "list_AOFdoBaHgkUy_choice_poNMdtvx7lHi"=>"Ask me more questions", "list_AOFdoBaHgkUy_choice_Oqvv5HXi5kyK"=>"Explain concepts clearly and share resources", "textarea_ummCANBFwJ5i"=>"Though he was very interested in helping me solve the lab. I had a question about using a selector in a specific way and why it wasn't working and using selectors dynamically which he seemed to either not know how to  use them how I wanted to or was concentrating on doing the whole lab. He also started talking about bootstrap and wanted to change all my class names to match bootstrap which would not help me since I have not gotten to that section (also had nothing to do with my question). He gave me a solution which I already knew was available (but wanted to do in a different way)."}}
