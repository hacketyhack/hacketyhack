#
# = Web =
#
# feeds and searches.
#
module Web
  JSON_MIME_TYPES = ["application/x-javascript", "application/x-json", "application/json"]
  XML_MIME_TYPES = ["application/rdf+xml", "application/rss+xml", "application/atom+xml", "application/xml", "text/xml"]
  [JSON_MIME_TYPES, XML_MIME_TYPES].each do |ary|
    ary.map! { |str| /^#{Regexp::quote(str)}/ }
  end
end

module Hpricot
  class Doc
    def widget(slot)
      ary = [:para, nil, []]
      children.each { |c| c.build_list(ary) }
      0.step(ary.length - 1, 3) do |i|
        case ary[i]
        when :image
          slot.send(ary[i], *ary[i+1])
        else
          unless ary[i+2].find_all { |x| !x.is_a?(String) or (x.gsub!(/^[\n\t]+|[\n\t]+$/, ''); x =~ /\S/) }.empty?
            slot.send(ary[i], ary[i+2], ary[i+1])
          end
        end
      end
    end
    def to_s
      (self/"//*/text()").join("  ").gsub(/\n+^Z/, '')
    end
    def length
      to_s.length
    end
  end
  module Traverse
    def build_list(ary, top = ary, inside = false) end
  end
  class Elem
    def build_list(ary, top = ary, inside = false)
      key, opts, text, block = nil, nil, nil, nil
      case name
      when "a";           key, opts = :link, {:click => self['href']}
      when "b", "strong"; key = :strong
      when "i", "em";     key = :em
      when "sup";         key = :sup
      when "sub";         key = :sub
      when "br";          text = "\n"
      when "img";         block, opts = :image, [self['src']]
      when "p";           block = :para
      when "blockquote";  block, opts = :para, {:margin => 20}
      when "li";          block, opts = :para, {:margin => 10}
      end

      if key
        ary2 = [key, opts, []]
        children.each { |c| c.build_list(ary2, top, true) }
        unless ary2.last.empty?
          unless ary2.last.find_all { |x| !x.is_a?(String) or (x.gsub!(/^\n+|\n+$/, ''); x =~ /\S/) }.empty?
            ele = HH::APP.send(ary2[0], ary2[2], ary2[1])
            ary.last << ele
          end
        end
      elsif text
        ary.last.last << text if ary.last.last.is_a? String
      elsif block == :image
        if ary[0] == :link
          opts << {:click => ary[1]}
        end
        top[-3,0] = [:image, opts, nil]
      elsif block
        if !inside
          ary << block << opts << []
        end
        children.each { |c| c.build_list(ary, top, true) }
      else
        children.each { |c| c.build_list(ary, top, inside) }
      end
      ary
    end
  end
  class Text
    def build_list(ary, top = nil, inside = false)
      ary = ary.last
      txt = self.inner_text
      txt.gsub!(/\r\n/, "\n")
      txt.gsub!(/\n+/, "\n")
      if ary.last.is_a? String
        ary.last << txt
      elsif txt =~ /\S/
        ary << txt
      end
      ary
    end
  end
end

class Feed
  attr_accessor :title, :link, :description, :items
  def initialize(t, l, d, i)
    @title, @link, @description, @items = t, l, d, i
  end
  def widget(slot) 
    slot.stack(:margin => 18).tap do |s|
      s.inscription "Feed from #{self.link}"
      s.title self.title
      s.para self.description if self.description
      items.each do |item|
        item.widget(s)
      end
    end
  end
  def to_s
    res = "Feed from #{link}\n"
    res << "== #{title} ==\n"
    res << "#{description}" if description
    res << " (#{items.size} items)\n"
  end
  def each(&blk)
    items.each(&blk)
  end
  def self.parse(data)
    doc = Hpricot.XML(data)
    if doc.at("/rss, /feed, rdf:rdf, rdf:RDF")
      Feed.load(doc)
    elsif link = doc.at("link[@type='application/atom+xml'], link[@type='application/rss+xml']")
      URI(link['href'])
    else
      doc
    end
  end
  def self.load(doc)
    title = (doc/"feed/title, channel/title").inner_text
    link = doc.at("feed/link, channel/link")
    link = link['href'] || link.inner_text
    description = (doc/"feed/tagline, channel/description").inner_text
    items = []
    (doc/"feed/entry, item").each do |item|
      ilink = item.at("/link")
      desc = item.at("content:encoded, content, description")
      if desc.to_s =~ /<\w+( |>)/n
        desc = Hpricot(desc.inner_text)
      end
      items << Feed::Item.new((item/"/title").inner_text,
        ilink['href'] || ilink.inner_text,
        desc)
    end
    self.new(title, link, description, items)
  end
end

class Feed::Item
  attr_accessor :title, :link, :description
  def to_s; "(Feed::Item)" end
  def initialize(t, l, d)
    @title, @link, @description = t, l, d
  end
  def widget(slot)
    slot.stack.tap do |s|
      s.para s.link(self.title, :click => self.link, :size => 18, :stroke => "#777"),
        " Feed::Item", :stroke => "#999"
      if self.description.respond_to? :widget
        self.description.widget(s)
      else
        s.para self.description
      end
    end
  end
  def to_s
    res = "== #{title} ==\n"
    res << "#{description}\n"
  end
end

# downloads the file at URI to filename showing the progress in a window
# if filename is a relative path, the file will be saved to the Downloads
# directory of HH, by default the basename of the URI is used
def Web.download uri, filename=nil, &blk
  filename ||= File.basename(uri)
  filename = File.expand_path(filename,  "#{HH::USER}/Downloads/")
  opts = {:save => filename }

  Web.dowload_dialog uri, opts, &blk
end

def Web.dowload_dialog uri, opts = {}, &blk
  window :width => 450, :height => 100, :margin => 10, :title => "Download" do
    # method to close the window
    def self.finished
      timer 1 do
        close
      end
    end

    status = para "Downloading #{uri}"
    p = progress :width => 1.0

    opts[:start] = proc{|dl| status.text = 'Connecting'}
    opts[:progress] = proc do |dl|
        status.text = "Transferred #{dl.transferred} of #{dl.length} bytes (#{dl.percent}%)"
        p.fraction = dl.percent * 0.01
    end

    opts[:finish] = proc do |dl|
      status.text = 'Download finished'
      finished
      blk.call(dl) if blk
    end
    opts[:error] = proc{|dl, err| status.text = "Error: #{err}"; finished}
    HH::APP.download uri, opts
  end
end

def Web.fetch(uri, opts = {}, &blk)
  Web.dowload_dialog uri, opts do |dl|
    data = dl.response.body
    unless opts[:as]
      opts[:as] =
        case dl.response.headers['Content-Type']
        when *Web::JSON_MIME_TYPES; JSON
        when *Web::XML_MIME_TYPES; Feed
        end
    end
    if opts[:as]
      if opts[:as].respond_to? :parse
        obj = opts[:as].parse(data)
        if obj.is_a? URI
          Web.fetch(obj, opts, &blk)
        else
          blk[obj]
        end
      elsif opts[:as] == String
        blk[data]
      else
        raise ArgumentError, "Web.fetch can't load into the #{opts[:as]} class"
      end
    else
      blk[data]
    end
  end
end

def Web.delicious(search, opts = {})
  search = search.try(:join, " ")
  opts[:limit] ||= 10
  url = "setcount=#{opts[:limit]}"
  search = "\"#{search}\"" if opts[:exact]
  if opts[:page].to_i > 1
    url += "&page=#{opts[:page]}"
  end

  HH::APP.download("http://del.icio.us/search?p=#{URI.escape(search)}&#{url}") do |doc|
    dls = Hpricot(doc.response.body)
    list = (dls/"div.data").map do |ele|
      link, meta = ele.at("h4 a"), ele.at(".delNavCount")
      Feed::Item.new(link.inner_text, link['href'], "saved by #{meta.inner_text} people")
    end
    yield Feed.new("del.icio.us", "http://del.icio.us/",
      "Delicious search for #{search}", list)
  end
end

def Web.flickr(search, opts = {})
  search = search.try(:join, " ").split(/\s+/).join(",")
  HH::APP.download("http://api.flickr.com/services/feeds/photos_public.gne?tags=#{URI.escape(search)}") do |doc|
    yield Feed.load(Hpricot(doc.response.body))
  end
end

def Web.google(search, opts = {})
  search = search.try(:join, " ")
  opts[:limit] ||= 10
  url = "num=#{opts[:limit]+3}"
  search = "\"#{search}\"" if opts[:exact]
  if opts[:page].to_i > 1
    url += "&start=#{opts[:limit] * (opts[:page].to_i - 1)}"
  end
  if opts[:site]
    if opts[:site].respond_to?(:join)
      search += "( site:#{opts[:site].join(' | site:')} )"
    else
      search += " site:#{opts[:site]}"
    end
  end

  HH::APP.download("http://www.google.com/search?q=#{URI.escape(search)}&#{url}") do |doc|
    ggl = Hpricot(doc.response.body)
    list = (ggl/".g")[0,opts[:limit]].map do |ele|
      link = ele.at("a")
      Feed::Item.new(link.inner_text, link['href'], (ele/(".s:first".."br")).inner_text)
    end
    yield Feed.new("Google", "http://google.com/",
      "Google search for: #{search}", list)
  end
end

def Web.yahoo(search, opts = {})
  search = search.try(:join, " ")
  opts[:limit] ||= 10
  url = "n=#{opts[:limit]}"
  search = "\"#{search}\"" if opts[:exact]
  if opts[:page].to_i > 1
    url += "&b=#{opts[:limit] * (opts[:page].to_i - 1)}"
  end
  url += "&vs=#{URI.escape([*opts[:site]].join(" | "))}" if opts[:site]

  HH::APP.download("http://search.yahoo.com/search?p=#{URI.escape(search)}&#{url}") do |doc|
    yahoo = Hpricot(doc.response.body)
    list = (yahoo/"div#web li").map do |ele|
      link = ele.at(".yschttl")
      next unless link
      Feed::Item.new(link.inner_text, link['href'], (ele/".abstr, .sm-abs").inner_text)
    end.compact
    yield Feed.new("Yahoo!", "http://yahoo.com/",
      "Yahoo! search for: #{search}", list)
  end
end
