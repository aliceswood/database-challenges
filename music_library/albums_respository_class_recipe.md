# Album Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: albums

Columns:
id | title | release_year | artist_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Doolittle', '1989', 1);
INSERT INTO albums (title, release_year, artist_id) VALUES ('Waterloo', '1972', 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < spec/seeds_albums.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)

class Album

  # Replace the attributes by your own columns.
   attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums

# Repository class
# (in lib/album_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Album objects.
  end

  # Returns one record
  # Takes the album id as an argument
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;

    # returns a single artist object
  end

  # creates a new album
  # Takes an Album object as an argument
  def create(album)
    # Executes the SQL query:
    # INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);

    # returns nil (only creates the record)
  end

  # Deletes an album
  # Based on the album id
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM albums WHERE id = $1;

    #returns nil (only deletes the record)
  end

  # Updates album details
  # Takes an album object (with the new details) as an arg
  def update(album)
    # Executes the SQL query:
    # UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;

    # returns nil (only updates the album details)
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all albums

repo = AlbumRepository.new

albums = repo.all

albums.length # => 2
albums.first.title # => 'Doolittle'
albums.first.release_year # => '1989'
albums.first.artist_id # => 1

# 2
# Finds details for 1 album

repo = AlbumRepository.new

albums = repo.find(3)

albums.title # => 'Super Trouper'
albums.release_year # => '1972'
albums.artist_id # => 2

# 3 
# Creates a new album

repo = AlbumRepository.new

album = Album.new
album.name = 'Voulez Vous'
album.release_year = '1989'
album.artist_id = '2'

repo.create(album) # => nil

albums = repo.all

last_album = album.last
last_album.name # => 'Voulez Vous'
last_album.release_year # => '1979'
last_album.artist_id # => '2'

# 4 
# it deletes an album

repo = AlbumRepository.new

id_to_delete = 1

repo.delete(id_to_delete) # => returns nil

all_albums = repo.all
all_albums.length # => 1
all_allbums.first.id # => '2'

# 5 
# it deletes all albums

repo = AlbumRepository.new

repo.delete(1) # => returns nil
repo.delete(2) # => returns nil

all_albums = repo.all
all_albums.length # => 0

# 6 
# it updates the album details

repo = AlbumRepository.new

album = repo.find(1)
album.title = 'Something else'
album.release_year = '1900'
album.artist_id = '2'

repo.update(album)

updated_album = repo.find(1)

updated_album.title # => 'Something else'
updated_album.release_year # => '1900'
updated_album.artist_id # => '2'

# 7 
# it updates some of the album details

repo = AlbumRepository.new

album = repo.find(1)
album.release_year = '1900'
album.artist_id = '2'

repo.update(album)

updated_album = repo.find(1)

updated_album.title # => 'Doolittle'
updated_album.release_year # => '1900'
updated_album.artist_id # => '2'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumsRepository do
  before(:each) do 
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
