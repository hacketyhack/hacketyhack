class HH::SideTabs
  include HH::Observable
  ICON_SIZE = 16
  HOVER_WIDTH = 140
  def initialize slot, dir
    @slot, @directory = slot, dir
    @n_tabs = {:top => 0, :bottom => 1}
    # tabs whose file has been loaded
    @loaded_tabs = {}
    sidetabs = self
    width = HOVER_WIDTH;
    append_to @slot do
      tip = nil
      right = stack :margin_left => 38, :height => 1.0
      left = stack :top => 0, :left => 0, :width => 38, :height => 1.0 do
        tip = stack :top => 0, :left => 0, :width => width, :margin => 4,
                    :hidden => true do
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

  # +opts+ is an hash
  # if a block is given no file gets loaded
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
    width = HOVER_WIDTH+22;
    append_to @left do
      stack pos => pixelpos, :left => 0, :width => 38, :margin => 4 do
        bg = background "#DFA", :height => 26, :curve => 6, :hidden => true
        image(icon_path, :margin => 4).
          hover do
            bg.show
            tip.parent.width = width
            tip.top = nil
            tip.bottom = nil
            tip.send("#{pos}=", pixelpos)
            tip.contents[1].text = hover
            tip.show
          end.leave do
            bg.hide
            tip.hide
            tip.parent.width = 40
          end.click &onclick
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
    emit :tab_opened, symbol
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
    # effectively redirects event to HH::APP
    @__side_tab_class.on_event :tab_opened, :any do |newtab|
      emit :tab_opened, newtab
    end
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
  def initialize slot
    @slot = slot
    slot.append do
      @content = flow :hidden => true, :left => 0, :top => 0,
                      :width => 1.0, :height => 1.0 do content end
    end
  end

  def open
    on_click
    if has_content?
      @content.show
    end
  end

  def close
    if has_content?
      @content.hide
    end
  end

  def clear &blk
    @content.clear &blk
  end

  def reset
    clear {content}
  end

  def has_content?
    self.class.method_defined?(:content)
  end

  def method_missing symbol, *args, &blk
    #slot = @slot
    @slot.app.send symbol, *args, &blk
  end

  def on_click
    # by default does nothing
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

