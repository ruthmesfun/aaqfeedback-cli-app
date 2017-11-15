class AaqFeedback::API
  # use RestClient to open the API
  # use JSON to parse the data
  # iterate through the data and create technical coach objects
  TECHNICALCOACH = []
  def self.data_list
    data = RestClient.get('https://api.typeform.com/v1/form/TW4DdU?key=0467013b2367a06ce1c32423a7b2f43483fce397')
    @data_hash = JSON.parse(data)

    @data_hash["responses"].each do |response|
      response["answers"].each do |tech, value|
        if value == "Technical Coach"
          TECHNICALCOACH << response
          binding.pry
        end
      end
    end
  end
end

# @data_hash["responses"][18]["answers"]
# => {"list_64949235_choice"=>"Technical Coach",
#  "list_64196466_choice_80218156"=>"Daniel",
#  "rating_MIWlzH1BLFWb"=>"5",
#  "list_z3PoGEKivPJy_choice_w5gBmbDDFw8U"=>
#   "Guide me while I debug my code",
#  "list_z3PoGEKivPJy_choice_Es8ECIWFTZ7a"=>
#   "I was able to speak to them immediately and have a screenshare quickly",
#  "list_z3PoGEKivPJy_choice_DXnkiNkeYsDl"=>
#   "Explain concepts clearly and concisely",
#  "list_AOFdoBaHgkUy_other"=>"None, it was great",
#  "textarea_ummCANBFwJ5i"=>"Fantastic!"}

#@data_hash["responses"][18]["answers"].has_value?("Daniel")
# => true
# collect to grab all
