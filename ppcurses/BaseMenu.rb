

class BaseMenu

  def setSubMenu(menu)
    @subMenu = menu
  end

  def hide()
    @win.clear
    @win.refresh

    @subMenu.hide() if @subMenu      
  end

end
