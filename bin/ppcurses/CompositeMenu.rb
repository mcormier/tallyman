
class CompositeMenu

  def initialize(menu1, menu2)
    @menu1 = menu1
    @menu2 = menu2

    @menu1.setSubMenu(menu2)

  end

  def show()
    @menu1.show()
    @menu2.show()
  end


  def getMenuSelection()
   @menu1.getMenuSelection() 
  end

end
