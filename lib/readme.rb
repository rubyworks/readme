# Readme is designed to parse a README file applying various hueristics
# in order to descern metadata about a project.
#
# The heuristics are fairly simplistic  at this point, but will improve
# with time and contribution.
#
class Readme

  if RUBY_VERSION < '1.9'
    require 'readme/version'
    require 'readme/cli'
  else
    require_relative 'readme/version'
    require_relative 'readme/cli'
  end

  # File glob for matching README file.
  FILE_PATTERN = "README{,.*}"

  #
  def self.file(path=Dir.pwd)
    if File.directory?(path)
      path = Dir.glob(File.join(path, FILE_PATTERN), File::FNM_CASEFOLD).first
    end
    if path
      new(File.read(path), path)
    else
      raise IOError, "no such README -- #{path}"
    end
  end

  #
  def initialize(text, file=nil)
    @text  = text
    @file  = file
    @data = {}
    parse
  end

  #
  # The ERADME file path, if provided.
  #
  attr :file

  #
  # The README text.
  #
  attr :text

  #
  # Location of README file, if file was provided.
  #
  # @return [String] Directory of README file
  #
  def root
    File.dirname(file) if file
  end

  #
  # The full README text.
  #
  # @return [String] The complete README text.
  #
  def to_s
    text.to_s
  end

  #
  # Access to underlying parse table.
  #
  def [](name)
    @data[name.to_s]
    #return nil unless file
    #if respond_to?(name)
    #  __send__(name)
    #else
    #  nil
    #end
  end

  #
  def name
    @data['name']
  end

  #
  def title
    @data['title']
  end

  #
  def description
    @data['description']
  end

  #
  def license
    @data['license']
  end

  #
  def copyright
    @data['copyright']
  end

  #
  def authors
    @data['authors']
  end

  #
  def resources
    @data['resources'] ||= {}
  end

  #
  def homepage
    resources['home']
  end

  #
  def wiki
    resources['wiki']
  end

  #
  def issues
    resources['issues']
  end

  #
  # Return file extension of README. Even if the file has no extension,
  # this method will look at the contents and try to determine it.
  #
  # @todo Improve type heuristics.
  #
  # @return [String] Extension type, e.g. `.md`.
  #
  def extname
    ext = File.extname(file)
    if ext.empty?
      ext = '.rdoc' if /^\=/ =~ text
      ext = '.md'   if /^\#/ =~ text
    end
    return ext
  end

  #
  # Access to a copy of the underlying parse table.
  #
  # @return [Hash] Copy of the underlying table.
  #
  def to_h
    @data.dup
  end

private

  #
  def parse
    parse_title
    parse_description
    parse_license
    parse_copyright
    parse_resources
  end

  #
  def parse_title
    if md = /^[=#]\s*(.*?)$/m.match(text)
      title = md[1].strip
      @data['title'] = title
      @data['name']  = title.downcase.gsub(/\s+/, '_')
    end
  end

  #
  def parse_description
    if md = /[=#]+\s*(DESCRIPTION|ABSTRACT)[:]*(.*?)[=#]/mi.match(text)
      @data['description'] = md[2].strip #.sub("\n", ' ')  # unfold instead of sub?
    else
      d = []
      o = false
      text.split("\n").each do |line|
        if o
          if /^(\w|\s*$)/ !~ line
            break d
          else
            d << line
          end
        else
          if /^\w/ =~ line
            d << line
            o = true
          end
        end
      end
      @data['description'] = d.join(' ').strip
    end
  end

  #
  def parse_license
    if md = /[=]+\s*(LICENSE)/i.match(text)
      section = md.post_match
      @data['license'] = (
        case section
        when /LGPL/
          "LGPL"
        when /GPL/
          "GPL"
        when /MIT/
          "MIT"
        when /BSD/
          "BSD"
        end
      )
    end
  end

  #
  def parse_copyright
    md = /Copyright.*?\d+(.*?)$/.match(text)
    if md
      copyright = md[0]

      authors = md[1].split(/(and|\&|\,)/).map{|a|a.strip}
      authors = authors.map{ |a| a.sub(/all rights reserved\.?/i, '').strip.chomp('.') }

      @data['copyright'] = copyright
      @data['authors']   = authors
    end
  end

  #
  def parse_resources
    @data['resources'] = {}

    scan_for_github
    scan_for_google_groups

    text.scan(/(\w+)\:\s*(http:.*?[\w\/])$/) do |m|
      @data['resources'][$1] = $2
    end
  end

  #
  # TODO: Improve on github matching.
  def scan_for_github
    text.scan(/http\:.*?github\.com.*?[">)\s]/) do |m|
      case m
      when /wiki/
        @data['resources']['wiki'] = m[0...-1]
      when /issues/
        @data['resources']['issues'] = m[0...-1]
      else
        if m[0] =~ /:\/\/github/
          @data['resources']['code'] = m[0...-1]
        else
          @data['resources']['home'] = m[0...-1]
        end
      end
    end
  end

  #
  def scan_for_google_groups
    if m = /http\:.*?groups\.google\.com.*?[">)\s]/.match(text)
      @data['resources']['mail'] = m[0][0...-1]
    end
  end

  #
  # TODO: parse readme into sections of [label, text].
  #def sections
  #  @sections ||= (
  #    secs = text.split(/^(==|##)/)
  #    secs.map do |sec|
  #      i = sec.index("\n")
  #      n = sec[0..i].sub(/^[=#]*/, '')
  #      t = sec[i+1..-1]
  #      [n, t]
  #    end
  #  )
  #end
end

