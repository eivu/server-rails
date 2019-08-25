# i = ItunesLibrary.new
# ti=track_info = ItunesTrackInfo.new(rt)
# ItunesLibrary.new.ingest_and_indentify


class ItunesLibrary

  attr_reader :path, :parser, :tracks, :raw_tracks

  def initialize(path="", bucket=1)
    path    = "/Users/jinx/Music/iTunes/iTunes\ Music\ Library.xml" if path.blank?
    @path   = path
    @bucket = Bucket.determine(bucket)
    @parser = ItunesParser.new(:file => @path)
    @raw_tracks = @parser.tracks.values
    # @tracks = @raw_tracks.collect {|raw_track| ItunesTrackInfo.new(raw_track)}
    @num_tracks = @raw_tracks.count
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


  def ingest_and_indentify
    @tracks.each do |raw_track_info|
      track_info = ItunesTrackInfo.new(raw_track_info)
      binding.pry
      cloud_file = CloudFile.ingest(track_info.path_to_file, @bucket, :itunes_track_info => track_info)
    end
  end


end