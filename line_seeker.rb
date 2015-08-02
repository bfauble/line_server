
class LineSeeker < Sinatra::Base
  def initialize(app = nil, params = {})
    super(app)
    @lines_array = []
    @count = 0
    @files = Dir.glob('temp/*').sort
    @files.each do |item|
      next if item == '.' || item == '..'
      file = File.new(item)
      @lines_array << file.each_line
      @count += file.each_line.count
    end
  end

  get '/test/:line' do |n|
    line = Integer(n) rescue nil
    if line.nil? || line > @count
      status 413
      'Status 413: Request Entity Too Large'
    else
      get_line(line)
    end
  end

  private

  def get_line(line)
    if line % 10_000 == 0
      @lines_array[line / 10_000 - 1].rewind
      "#{@lines_array[line / 10_000 - 1].take(10_000).last}"
    else
      @lines_array[line / 10_000].rewind
      "#{@lines_array[line / 10_000].take(line % 10_000).last}"
    end
  end
end
