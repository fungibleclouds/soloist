module Soloist
  module Util
    def with_or_without_dot(file_name)
      [file_name, ".#{file_name}"]
    end
    
    def fileify(contents)
      file = Tempfile.new("soloist")
      puts "==== Temp File Contents ====\n#{contents}" if ENV['LOG_LEVEL'] == 'debug'
      file << contents
      file.flush
      file
    end
    
    def walk_up_and_find_file(filenames, opts={})
      pwd = FileUtils.pwd
      file = nil
      path_to_file = ""
      while !file && FileUtils.pwd != '/'
        file = filenames.detect { |f| File.exists?(f) }
        FileUtils.cd("..")
        path_to_file << "../" unless file
      end
      FileUtils.cd(pwd)
      if file
        file_contents = File.read(path_to_file + file) if file
        [file_contents, path_to_file]
      elsif opts[:required] == false
        [nil, nil]
      else
        raise Errno::ENOENT, "#{filenames.join(" or ")} not found" unless file || opts[:required] == false
      end
    end

    # stolen from activesupport
    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end
  end
end