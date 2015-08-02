
class LineSeeker < Sinatra::Base
  def initialize(app = nil, params = {})
    @file_name = params[:file_name]
    @lines_hash = {}
    @count = 0
    initialize_files
    super(app)
  end

  get '/lines/:line' do |n|
    line = Integer(n) rescue nil
    if line.nil? || line < 1
      status 415
      'Status 415: The server is refusing to service the request because the entity of the
      request is in a format not supported by the requested resource for the requested method.'
    elsif line > @count
      status 413
      'Status 413: Request Entity Too Large'
    else
      get_line(line)
    end
  end

  private

  def initialize_files
    i = 0
    @files = Dir.glob('temp/*').sort
    @files.each do |item|
      next if item == '.' || item == '..'
      @lines_hash[i] = item
      i += 1
    end
    @count = %x{wc -l "#{@file_name}"}.split[0].to_i
  end

  def get_file(line)
    if line % 10_000 == 0
      @lines_hash[line / 10_000 - 1]
    else
      @lines_hash[line / 10_000]
    end
  end

  def get_line(line)
    file = get_file(line)
    File.open(file) do |f|
      if line % 10_000 == 0
        "#{f.each_line.take(10_000).last}"
      else
        "#{f.each_line.take(line % 10_000).last}"
      end
    end
  end
end
