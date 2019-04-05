class ItunesLibrary

  attr_reader :path, :parser, :tracks

  def initialize(path="")
    path   = "/Users/jinx/Music/iTunes/iTunes\ Music\ Library.xml" if path.blank?
    @path  = path
    @parser = ItunesParser.new(:file => @path)
    @tracks = @parser.tracks.values
    @num_tracks = @tracks.count
  end


  def playlists_to_ignore
    @ignore = [
      "Library",
      "Downloaded",
      "Music",
      "Movies",
      "TV Shows",
      # "Podcasts",
      "Audiobooks",
      "Genius",
      "Purchased",
      "90’s Music",
      "Music Videos",
      # "My Top Rated",
      # "Recently Added",
      # "Recently Played",
      # "Top 25 Most Played",
      # "Internet Songs"
    ]
  end


  def ingest
    @tracks.each do |raw_track_info|
      track_info = raw_track_info.simplify
      track_info[:total_time] = track_info[:total_time].to_i/1000
      mash = Hashie::Mash.new track_info
      binding.pry
      1
    end
  end


end