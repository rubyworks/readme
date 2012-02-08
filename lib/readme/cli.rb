class Readme

  require 'optparse'

  def self.cli(*argv)
    format = nil
    name   = nil

    OptionParser.new do |opt|
      opt.banner = 'Usage: readme [option] [field]'
      opt.on('-y', '--yml', '--yaml', 'return in YAML format') do
        format = :yaml
      end
      opt.on('-j', '--json', 'return in JSON format') do
        format = :json
      end
      opt.on('-r', '--ruby', 'return in Ruby code format') do
        format = :ruby
      end
      opt.on_tail('-h', '--help', 'show this help message') do
        puts opt
        exit
      end
    end.parse!(argv)
   
    if argv.first
      name = argv.shift
      data = Readme.file[name]
    else
      if format
        data = Readme.file.to_h
      else
        data = Readme.file
      end
    end

    case format
    when :yaml
      require 'yaml'
      puts data.to_yaml
    when :json
      require 'json'
      puts data.to_json
    when :ruby
      data = {name => data} if name
      data.each do |k,v|
        case v
        when Hash
          puts "#{k} #{v.inspect[1...-1]}"
        else
          puts "#{k} #{v.inspect}"
        end
      end
    else
      puts data #Readme.file.to_s
    end
  end

end
