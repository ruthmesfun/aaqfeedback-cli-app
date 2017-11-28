class AaqFeedback::API
  # use RestClient to open the API
  # use JSON to parse the data
  # iterate through the data and create technical coach objects
  SURVEYS = []

  def import
    data = RestClient.get('https://api.typeform.com/v1/form/TW4DdU?key=0467013b2367a06ce1c32423a7b2f43483fce397')
    @data_hash = JSON.parse(data)

    @data_hash["responses"].each do |response|
      response["answers"].each do |tech, value|
        if value == "Technical Coach"
          SURVEYS << response
        end
      end
    end
    SURVEYS
  end

  def surveys
    import
    SURVEYS
  end

end
