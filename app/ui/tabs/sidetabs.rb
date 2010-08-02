class HH::SideTabs
  ICON_SIZE = 16
  def initialize slot, dir
    @slot, @directory = slot, dir
    @n_tabs = {:top => 0, :bottom => 1}
    # tabs whose file has been loaded
    @loaded_tabs = {}
    sidetabs = self
    append_to @slot do
      tip = nil
      right = stack :margin_left => 38, :height => 1.0
      left = stack :top => 0, :left => 0, :width => 38, :height => 1.0 do
        tip = stack :top => 0, :left => 0, :width => 200, :margin => 4, :hidden => true do
          background "#F7A", :curve => 6
          para "HOME", :margin => 3, :margin_left => 40, :stroke => white
        end
        # colored background
        background "#cdc", :width => 38
        background "#dfa", :width => 36
        background "#fda", :width => 30
        background "#daf", :width => 24
        background "#aaf", :width => 18
        background "#7aa", :width => 12
        background "#77a", :width => 6
      end
      sidetabs.instance_eval{@left, @right, @tip = left, right, tip}
    end
  end

#  def method_missing symbol, *args, &blk
#    @slot.send symbol, *args, &blk
#  end

  # +opts+ is an hash
  # if block is given no file gets loaded
  def addtab symbol, opts={}, &blk
    # default options
    if not symbol.is_a?(Symbol)
      raise ArgumentError
    end
    tab = opts
    tab[:symbol] = symbol
    tab[:icon] ||= "icon-file.png"
    tab[:position] ||= :top
    tab[:hover] ||= symbol.to_s
    
    pos = tab[:position]
    pixelpos = @n_tabs[pos] * (ICON_SIZE + 10)
    @n_tabs[pos] += 1
    hover = tab[:hover]
    icon_path = HH::STATIC + "/" + tab[:icon]
    tip = @tip
    onclick = proc do
      opentab symbol
    end
    append_to @left do
      stack pos => pixelpos, :left => 0, :width => 38, :margin => 4 do
        bg = background "#DFA", :height => 26, :curve => 6, :hidden => true
        image(icon_path, :margin => 4).
          hover { bg.show; tip.parent.width = 222; tip.top = nil; tip.bottom = nil
            tip.send("#{pos}=", pixelpos); tip.contents[1].text = hover; tip.show }.
          leave { bg.hide; tip.hide; tip.parent.width = 40 }.
          click &onclick
      end
    end

    if blk
      @loaded_tabs[symbol] = HH::NoContentSideTab.new blk
    end
  end


  def opentab symbol
    tab = gettab symbol
    if tab.has_content?
      @current_tab.close if @current_tab
      @current_tab = tab
    end
    tab.open
  end

  def gettab symbol
    if @loaded_tabs.include? symbol
      return @loaded_tabs[symbol]
    else
      require "app/ui/tabs/#{symbol.downcase}.rb"
      @loaded_tabs[symbol] = self.class.const_get(symbol).new(@right)
    end
  end

private
  def append_to slot, &blk
    slot.app do
      slot.append {self.instance_eval &blk}
    end
  end
end

module HH::HasSideTabs
  def init_tabs slot, dir="app/ui/tabs"
    @__side_tab_class = HH::SideTabs.new slot, dir
  end

  # returns the created tab
  def addtab *args, &blk
    @__side_tab_class.addtab *args, &blk
  end
  
  def opentab symbol
    @__side_tab_class.opentab symbol
  end

  def gettab symbol
    @__side_tab_class.gettab symbol
  end
end

class HH::SideTab
  include HH::Observable
  def initialize slot
    @slot = slot
    slot.append do
      @content = flow :left => 0, :top => 0, :width => 1.0, :height => 1.0, :hidden => true do
        content
      end
    end
  end

  def open
    on_click
    if has_content?
      @content.show
    end
    emit :clicked
  end

  def close
    if has_content?
      @content.hide
    end
  end

  def has_content?
    self.class.method_defined?(:content)
  end

  def method_missing symbol, *args, &blk
    #slot = @slot
    @slot.app.send symbol, *args, &blk
  end

  def on_click
    # default does nothing
  end
end

class HH::NoContentSideTab < HH::SideTab
  def initialize blk
    @blk = blk
  end
  def on_click
    @blk.call
  end
end
#
#class Tab1 < HH::SideTab
#  def on_click
#    alert "test"
#  end
#end
#
#class Tab2 < HH::SideTab
#  def content
#    para "content"
#  end
#end
#
#module HH::SideTabs
#  class InexistentTab < ::RuntimeError; end
#  class InvalidTabFile < ::RuntimeError; end
#
#  def init_tabs
#    @content
#    @tabs = []
#    @loaded_tabs = Set.new
#    @has_content = true
#  end
#
#  def self.add tab
#    @@tabs << tab
#  end
#
#  def self.has_content?
#    return @@has_content
#  end
#
#  def self.run_tab tab
#    load_tab tab # assure file is loaded
#    tab_class = Kernel.const_get(tab)
#    if tab_class.has_content?
#
#    end
#  end
#
#  def self.load_tab tab
#    # load the file the first time
#    return if @@loaded_tabs.include? tab
#    begin
#      require "app/ui/tabs/#{tab.downcase}.rb"
#      # raise a name error if the tab class doesn't get defined
#      Kernel.const_get(tab)
#    rescue NameError
#      raise InvalidTabFile
#    end
#  end
#
#  def app
#    return HH::APP
#  end
#end
#
#class HH::SideTab
#
#end
