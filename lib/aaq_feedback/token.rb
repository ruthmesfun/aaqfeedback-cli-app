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
        list_name = "list_64196466_choice"
        if key.include?(list_name)
          token.technical_coaches << value
        end
      end

      token.rating = survey["answers"]["rating_MIWlzH1BLFWb"].to_i

      #unique comments from students
      token.regular_comment = survey["answers"]["textarea_ummCANBFwJ5i"]
      token.other_positive_comment = survey["answers"]["list_z3PoGEKivPJy_other"]
      token.other_negative_comment = survey["answers"]["list_AOFdoBaHgkUy_other"]

      #feedback response -- positive and negative
      survey["answers"]. each do |key, value|
        positive_list_name = "z3PoGEKivPJy"
        negative_list_name = "AOFdoBaHgkUy"

        if key.include?(positive_list_name)
          token.positive_feedback << value
        elsif key.include?(negative_list_name)
          token.negative_feedback << value
        end
      end
      self.tokens << token
    end
  end
end
