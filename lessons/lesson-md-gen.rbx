# TODO don't forget to delete this file, and all the old DSL lesson .rb files.

module HH
  class STATIC
    def self.to_s
      #Dir.pwd + '/static'
      'static'
    end
  end
end

module MarkdownTranslator

  def lesson_set name
    puts "\n# #{name}"
    yield
  end

  def lesson name
    puts "\n## #{name}"
  end

  def page name
    puts "\n### #{name}"
    yield
  end

  def flow
    puts
    yield
  end

  def para *lines
    puts "\n" + lines.to_a.map { |line| line.to_s } * ''
  end

  def em text
    "_#{text}_"
  end

  def strong text
    "__#{text}__"
  end

  def icon_button(name_symbol, not_sure_but_is_nil, &block)
    msg = yield if block_given?
    puts "\n\n![#{msg || ''}](/icon_button/#{name_symbol})\n"
  end

  def alert(txt)
    txt
  end

  def image(path, opts={}, &block)
    msg = yield if block_given?
    puts "![#{msg || ''}](#{path})"
  end

  # On a page, this is basically a way of saying,
  # "Hey, when someone's on this page right here,
  # if they click the TAB that I'm naming here,
  # you should advance the lesson to the next page,
  # whatever it is."
  def next_when(tab_opened, tab_name)
    puts "<<Also, on this page ONLY, wire up the #{tab_name} tab to advance to the next page.>>"
  end

  def embed_code(code, opts={})
    code = code.lines.map { |line| "    #{line}" } * ''
    puts "\n#{code}\n"
  end

  def link(text, opts={})
    url = opts[:click]
    "[#{text}](#{url})"
  end
  
  def code(text)
    "`#{text}`"
  end
end

def ld
  load __FILE__
end

class MarkdownEmitter
  include MarkdownTranslator

  def puts(*s)
    @f.puts(*s)
  end

  def initialize(lesson_file)
    markdown_file = lesson_file.sub(File.extname(lesson_file), '.md')
    p "#{lesson_file} -> #{markdown_file}"
    File.open(markdown_file, 'w') do |f|
      @f = f    
      eval(File.read(lesson_file))
    end
  end
end

def run
  Dir.glob("#{File.dirname(__FILE__)}/**/*.rb").each do |lesson|
    MarkdownEmitter.new(lesson)
  end
end
