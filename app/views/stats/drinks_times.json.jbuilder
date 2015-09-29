
json.array! @series_map do |name, times|

    json.name name
    json.data do 
      json.array! times do |time|
        json.array! time
      end
    end

end


