
json.name "Drinks"
json.colorByPoint true
json.data do
  json.array! @drinks do |drink|
    json.name drink.name
    json.y    drink.drinks_count
  end
end





