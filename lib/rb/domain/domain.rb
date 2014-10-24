

# Modules are called domains in code because
# module is a reserved word in ruby.

class Domain

  attr_accessor :module_name
  attr_accessor :table_name
  attr_accessor :table_columns
  attr_accessor :main_menu_label

  def initialize
  end

  def create_action( db, config )
    PPCurses::NulAction.new
  end

  def config_action( config )
    PPCurses::NulAction.new
  end


  def create_table_statement
    'create table ' + table_name + ' ' + table_columns + ';'
  end

end