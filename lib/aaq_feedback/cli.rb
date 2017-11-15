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
      puts AaqFeedback::API.data_list
    elsif input == 2
      puts "Technical Coach"
    else
      puts "I don't understand that choice."
      menu
    end
  end
end
