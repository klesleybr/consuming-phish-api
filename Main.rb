require "./APIConsume"
require "./Database"

consume = APIConsume.new("https://phish.in/api/v2/")
db = Database.new(localhost, username, password, db_name)


api_data = consume.tracks(1500)

api_data["tracks"].each do |track|

  row_id_artist = 0
  artist = track["songs"][0]["artist"]
  if(artist != nil && artist != "")
    row_id_artist = db.insert_artists(artist)
  end

  db.insert_info(track["id"], track["title"], row_id_artist, track["mp3_url"], track["show_date"])

end

puts("\n>> JOIN de todos os registros do banco de dados:")
count = 1
all_registers = db.tracks_join()
all_registers.each do |r|
  puts("Tupla #{count}: {\"id\": #{r["id"]}, \"title\": #{r["title"]}, \"artist\": #{r["artist"]}, \"mp3_url\": #{r["mp3_url"]}, \"date_track\": #{r["date_track"]}}")
  puts("======================================================================================================================================================================")
  count += 1
end

