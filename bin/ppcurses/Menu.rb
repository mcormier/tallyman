# Curses reference:
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/curses/rdoc/Curses.html

require "./ppcurses/BaseMenu.rb"
require "curses"
include Curses

class Menu < BaseMenu

  def initialize( menuItems, actionItems )
    @items = Array.new

    @maxMenuWidth = 0

     menuItems.each do |item|
       @items.push item
       if item.length > @maxMenuWidth then @maxMenuWidth = item.length end
     end

    @selection = 0

    unless actionItems.nil? 
      @actions = Array.new
      actionItems.each do |item|
        @actions.push item      
      end
    end 
   
    winHeight = @items.length + 4 
    winWidth = @maxMenuWidth + 4
    @win = Window.new(winHeight,winWidth,(lines-winHeight) / 2, (cols-winWidth)/2)

    @win.timeout=-1
    # Enables reading arrow keys in getch 
    @win.keypad(true)
  end

  def show()
    @win.box("|", "-")
    y = 2
    x = 2

    for i in 0...@items.length
      @win.setpos(y, x)
      if @selection == i then @win.attron(A_REVERSE) end
      @win.addstr(@items[i])
      if @selection == i then @win.attroff(A_REVERSE) end
      y += 1
    end

   @win.refresh

   @subMenu.show() if @subMenu      
  end

  def setGlobalAction(action)
    @gAction = action
  end

  def getMenuSelection()

    while(1)
      c = @win.getch

      processed = self.handleMenuSelection(c)

      if c == 27 then # ESCAPE
        self.hide()
        break
      end

      if processed == false then
        @subMenu.handleMenuSelection(c) if @subMenu      
      end

    end 

  end
 
  def handleMenuSelection(c)
    n_choices = @items.length

    if c == KEY_UP then
      if @selection == 0 then @selection = n_choices-1 else @selection -= 1 end
      self.show()
      return true
    end

    if c == KEY_DOWN then
      if @selection == n_choices-1 then @selection = 0  else @selection += 1 end
      self.show()
      return true
    end

    if c == 10 then # ENTER

      unless @gAction.nil?
        @gAction.execute()
      end

      unless @actions.nil?
        @actions[@selection].execute()
      end

      self.show()
      return true
    end

    return false
  end


  def close()
    @win.close()
  end

end


