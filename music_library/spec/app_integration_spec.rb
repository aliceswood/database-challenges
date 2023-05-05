require_relative '../app.rb'
require 'album_repository'
require 'artist_repository'

RSpec.describe 'app integration' do
  it 'puts the welcome message' do
    io = double :io
    welcome_message = "Welcome to the music library manager!\n\nWhat would you like to do?\n 1 - List all albums\n 2 - List all artists\n\nEnter your choice:"

    expect(io).to receive(:puts).with(welcome_message).ordered

    app = Application.new( 
      'music_library_test',
      io,
      AlbumRepository.new,
      ArtistRepository.new
    )
    app.run
  end
end