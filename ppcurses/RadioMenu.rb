# Curses reference:
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/curses/rdoc/Curses.html

require "curses"
require './ppcurses/BaseMenu.rb'
include Curses

class RadioMenu  < BaseMenu

  def initialize( menuItems, actionItems )
    @items = Array.new

    @menuLength = 0

     menuItems.each do |item|
       @items.push item
        @menuLength += item.length + 5
     end

    @selection = 0

    unless actionItems.nil? 
      @actions = Array.new
      actionItems.each do |item|
        @actions.push item      
      end
    end 
   
    winWidth = @menuLength + 4

    @win = Window.new(3, winWidth ,0, (cols - winWidth) / 2)

    @win.timeout=-1
    # Enables reading arrow keys in getch 
    @win.keypad(true)
  end

  def show()
    @win.box("|", "-")
    y = 1
    x = 2

    @win.setpos(y, x)

    for i in 0...@items.length
      @win.addstr( @items[i] )
      if @selection == i then @win.addstr(" [*] ") else @win.addstr(" [ ] " ) end
    end

   @win.refresh

  end


  def getMenuSelection()

    while(1)
      c = @win.getch

      processed = self.handleMenuSelection(c)

      if c == 27 then # ESCAPE
        @win.clear
        @win.refresh
        break
      end

    end 

  end


  def handleMenuSelection(c)
    n_choices = @items.length

    if c == KEY_RIGHT then
      if @selection < n_choices - 1 then @selection += 1 else @selection = 0 end
      self.show()
    end

    if c == KEY_LEFT then
      if @selection > 0 then @selection -= 1 else @selection = n_choices-1 end
      self.show()
    end

    if c == 10 then # ENTER
      unless @actions.nil?
        @actions[@selection].execute()
        self.show()
      end
    end
  end
 


  def close()
    @win.close()
  end

end


