require "PG"
require "json"

class Database

  attr_accessor :localhost, :user, :password, :db_name, :db

  def initialize(localhost, user, password, db_name)

    @localhost = localhost
    @user = user
    @password = password
    @db_name = db_name

    PG.connect(host: @localhost, user: @user, password: @password, dbname: @db_name).exec("CREATE DATABASE tracks;")

    @db = PG.connect(host: @localhost, user: @user, password: @password, dbname: "tracks")
    @db.exec(
      "CREATE TABLE artists(
        id SERIAL NOT NULL PRIMARY KEY,
        name VARCHAR(150)
      );"
    )
    @db.exec("INSERT INTO artists (id, name) VALUES (0, 'Desconhecido(a)');")
    @db.exec(
      "CREATE TABLE info(
        id INT PRIMARY KEY NOT NULL,
        title VARCHAR(200) NOT NULL,
        artist_id INT REFERENCES artists(id),
        mp3_url TEXT NOT NULL,
        date_track DATE DEFAULT NULL      
      );"
    )

  end

  def insert_artists(name)

    f_name = name == nil ? name : name.gsub("'", " ")  

    existsArtist = @db.exec("SELECT id FROM artists WHERE name LIKE '#{f_name}';").to_a
    if(existsArtist.empty?)
      row_id = @db.exec("INSERT INTO artists (name) VALUES ('#{f_name}') RETURNING id;")
      return row_id[0]["id"]
    end

    return existsArtist[0]["id"]

  end

  def insert_info(id, title, artist_id, mp3_url, date_track)

    f_title = title == nil ? title : title.gsub("'", " ")    

    @db.exec("INSERT INTO info (id, title, artist_id, mp3_url, date_track) VALUES (#{id}, '#{f_title}', #{artist_id}, '#{mp3_url}', '#{date_track}');")
    puts("Dados inseridos com sucesso!")
    puts("Tupla: {\"id\": #{id}, \"title\": #{title}, \"artist_id\": #{artist_id}, \"mp3_url\": #{mp3_url}, \"date_track\": #{date_track}}")
    puts(("========================================================================================================================================="))

  end

  def select_all(table, limit = nil)

    query = "SELECT * FROM #{table}"
    f_query = limit_query(query, limit)
    return @db.exec(f_query).to_a.to_json  
    
  end

  def select_by_id(table, id)

    return @db.exec("SELECT * FROM #{table} WHERE id = #{id};").to_a.to_json

  end

  def select_by_title(title, limit = nil)

    query = "SELECT * FROM info WHERE title LIKE '%#{title}%'"
    f_query = limit_query(query, limit)
    return @db.exec(f_query).to_a.to_json

  end

  def select_by_artist(artist, limit = nil)

    f_artist = artist == nil ? artist : artist.gsub("'", " ")   
    query = "SELECT * FROM info WHERE artist_id IN (SELECT id FROM artists WHERE name LIKE '%#{f_artist}%')" 
    f_query = limit_query(query, limit)
    return @db.exec(f_query).to_a.to_json

  end

  def select_by_period(start_date, final_date, limit = nil)

    query = "SELECT * FROM info WHERE date_track BETWEEN '#{start_date}' AND '#{final_date}'"
    f_query = limit_query(query, limit)
    return @db.exec(f_query).to_a.to_json

  end

  def tracks_join(limit = nil)

    query = "SELECT info.id, info.title, artists.name AS artist, info.mp3_url, info.date_track FROM info INNER JOIN artists ON info.artist_id = artists.id"
    f_query = limit_query(query, limit)
    return @db.exec(f_query).to_a

  end

  def limit_query(query, limit)

    if(limit != nil)
      query = query + " LIMIT #{limit};"
    end
    return query

  end

end