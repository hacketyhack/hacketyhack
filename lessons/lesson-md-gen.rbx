module HH
  class STATIC
    def self.to_s
      '/static'
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
    puts "![#{msg || ''}](#{name_symbol})"
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
    lang = 'run_button' if opts[:run_button]
    puts "\n``` #{lang || ''}\n#{code}\n```\n"
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
  Dir.glob('**/*.rb').map { |lesson| MarkdownEmitter.new(lesson) }
end



<<EXAMPLE
lesson_set "A Tour of Hackety Hack" do

  lesson "Preferences"
  page "I do prefer..." do
    para "This lets you adjust your preferences for Hackety Hack. Right now, there's ",
         "only one preference: linking Hackety with your account on ",
         link("hackety-hack.com", :click => "http://hackety-hack.com"), ". You ",
         strong("do"), " have one of those, right?"
    para "If you link your account, you can upload your programs to the website ",
         "and easily share them with others! More interesting features will be ",
         "developed along these lines, so sign up, stick your info in, and prepare ",
         "for all kinds of awesome."
    para "I won't make you click the button to advance this time... instead, just ",
         "click the arrow to advance."
  end

  lesson "Quit"
  page "Self-explanatory" do
    para "If you did click the quit button, well, you wouldn't be here anymore. ",
         "And that'd be unfortunate. So, don't click it until you're good and ready. ",
         "When it's your time to go, it'll be there waiting for you. Come back soon!"
  end

  lesson "... and beyond!"
  page "What now?" do
    para "This concludes the Hackety Hack tour. Good job! Now you know everything ",
         "that Hackety Hack can do. It's pretty simple!"
    para "This isn't the only lesson that we have for you, though. Give the ",
         "'Basic Programming' lesson a shot to actually start learning how to ",
         "make programs of your own."
    para "What are you waiting for? Get going!"
  end

end

EXAMPLE
