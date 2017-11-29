class AaqFeedback::Token
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
end
