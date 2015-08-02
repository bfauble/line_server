Bundler.require
require './line_seeker'
run LineSeeker.new(nil, file_name: ENV['FILE_NAME'])
