class AaqFeedback::CLI
#responsible for getting data from the user and displaying data

  def call
    puts "Welcome to the AAQ Feedback Report Gem."
    puts ""
    menu
  end

  def menu
    puts "Please select a number to select your choice"
    puts "1. Overall data"
    puts "2. Technical Coach"

    input = gets.strip.to_i

    if input == 1
      puts " Would you like 1. All data, 2. Average rating, 3.Frequency"
      input = gets.strip.to_i

      AaqFeedback::Report.find_and_create_from_survey

      if input == 1
        puts AaqFeedback::Report.tokens
      elsif input == 2
        puts AaqFeedback::Report.average_rating
      elsif input == 3
        puts AaqFeedback::Report.frequency_of_positive_feedback
      end
    elsif input == 2
      puts "Technical Coach"
    else
      puts "I don't understand that choice."
      menu
    end
  end
end
