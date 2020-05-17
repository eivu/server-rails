# i = ItunesLibrary.new
# ti=track_info = ItunesTrackInfo.new(rt)
# ItunesLibrary.new.ingest_and_identify


class Library::Itunes

  attr_reader :path, :parser, :tracks, :raw_tracks, :num_tracks

  def initialize(path)
    @path   = path
    @parser = ItunesParser.new(:file => @path)
    @raw_tracks = @parser.tracks.values
    @tracks = @raw_tracks.collect {|raw_track| Itunes::Track.new(raw_track)}
    @num_tracks = @raw_tracks.count
  end

  def inspect
    self.class.name
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


  def ingest_and_identify
    @tracks.each do |raw_track_info|
      track_info = Itunes::Track.new(raw_track_info)
      binding.pry
      CloudFileIngesterJob.perform_now(path_to_item, @bucket, :itunes_track_info => track_info)
    end
  end


end