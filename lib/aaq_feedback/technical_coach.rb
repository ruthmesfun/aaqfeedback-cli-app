class AaqFeedback::TechnicalCoach
  attr_accessor :report, :name, :feedback

# Grab the ratings of the technical coaches
# Grab the frequency for the technical coaches
  @@tokens = []

  def initialize(name)
    @name = name

    @feedback = []
  end

  def self.tokens
    @@tokens
  end
  



end
