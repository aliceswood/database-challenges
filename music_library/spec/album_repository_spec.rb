require 'album_repository'

RSpec.describe AlbumRepository do

  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_albums_table
  end
  
  it 'returns a list of albums' do
    repo = AlbumRepository.new

    albums = repo.all

    expect(albums.length).to eq(2)
    expect(albums.first.title).to eq('Doolittle')
    expect(albums.first.release_year).to eq('1989')
    expect(albums.first.artist_id).to eq('1')
  end


  it 'returns Doolittle' do
    repo = AlbumRepository.new

      albums = repo.find(1)
      expect(albums.title).to eq('Doolittle')
      expect(albums.release_year).to eq('1989')
      expect(albums.artist_id).to eq('1')
    end

  it 'creates a new album' do
    repo = AlbumRepository.new

    album = Album.new
    album.title = 'Voulez Vous'
    album.release_year = '1979'
    album.artist_id = '2'

    repo.create(album) # => nil

    albums = repo.all

    last_album = albums.last
    expect(last_album.title).to eq('Voulez Vous')
    expect(last_album.release_year).to eq('1979')
    expect(last_album.artist_id).to eq('2')
  end

  it 'deletes album with id 1 from the list' do
    repo = AlbumRepository.new

    id_to_delete = 1

    repo.delete(id_to_delete)

    all_albums = repo.all
    expect(all_albums.length).to eq(1)
    expect(all_albums.first.id).to eq('2')
  end

  it 'deletes all albums' do
    repo = AlbumRepository.new

    repo.delete(1)
    repo.delete(2)

    all_albums = repo.all
    expect(all_albums.length).to eq(0)
  end

  it 'updates the album details' do
    repo = AlbumRepository.new

    album = repo.find(1)
    album.title = 'Something else'
    album.release_year = '1900'
    album.artist_id = '2'

    repo.update(album)

    updated_album = repo.find(1)

    expect(updated_album.title).to eq('Something else')
    expect(updated_album.release_year).to eq('1900')
    expect(updated_album.artist_id).to eq('2')
  end

  it 'updates some of the album details' do 
    repo = AlbumRepository.new

    album = repo.find(1)
    album.release_year = '1900'
    album.artist_id = '2'

    repo.update(album)

    updated_album = repo.find(1)

    expect(updated_album.title).to eq('Doolittle')
    expect(updated_album.release_year).to eq('1900')
    expect(updated_album.artist_id).to eq('2')
  end
end