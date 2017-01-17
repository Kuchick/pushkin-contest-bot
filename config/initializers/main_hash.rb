file = File.open("poems-full.json")
content = file.read
raw_hash = JSON.parse(content)
$main_hash = {}

raw_hash.each do |arr|
  arr[1].each do |string_of_poem|
    $main_hash[string_of_poem] = arr[0]
  end
end