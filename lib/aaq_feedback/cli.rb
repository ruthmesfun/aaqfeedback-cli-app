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
      while input > 0
        puts " Would you like 1. All data, 2. Average rating, 3.Frequency, 4. All of the above, 5. End"
        input = gets.strip.to_i

        AaqFeedback::Report.find_and_create_from_survey
          case input
          when 1
            puts AaqFeedback::Report.tokens
            puts "\n to end this app type 0"
            input = gets.strip.to_i
          when 2
            puts "What month would you like an to choose from? 1-12"
            month = gets.strip
            puts AaqFeedback::Report.average_rating(month)
            puts "\n to end this app type 0"
            input = gets.strip.to_i
          when 3
            puts "What month would you like an to choose from? 1-12"
            month = gets.strip

            puts "POSITIVE FEEDBACK \n-----------------"
            puts AaqFeedback::Report.frequency_of_positive_feedback(month)
            puts "\n \n "
            puts "NEGATIVE FEEDBACK \n-----------------"
            puts AaqFeedback::Report.frequency_of_negative_feedback(month)
            puts "\n to end this app type 0"
            input = gets.strip.to_i
          when 4
            puts "What month would you like an to choose from? 1-12"
            month = gets.strip

            puts "AVERAGE RATING \n-----------------"
            puts AaqFeedback::Report.average_rating(month)
            puts "POSITIVE FEEDBACK \n-----------------"
            puts AaqFeedback::Report.frequency_of_positive_feedback(month)
            puts "\n \n "
            puts "NEGATIVE FEEDBACK \n-----------------"
            puts AaqFeedback::Report.frequency_of_negative_feedback(month)
            puts "\n to end this app type 0"
            input = gets.strip.to_i
          end

          puts "Thank you for trying out the Technical Coach Feedback App!"
        end
      elsif input == 2
        puts "Technical Coach"
      else
        puts "I don't understand that choice."
        menu
      end
    end
end
