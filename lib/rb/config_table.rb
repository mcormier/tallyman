class ConfigTable < PPCurses::TableView

end

class DomainDataSource < PPCurses::MultipleColumnDataSource


  def initialize( domains, config )
    @values = domains		
	@config = config
  end

  def object_value_for(aTableview, column, row_index)
    
	# TODO if column == 0 then convert boolean to checkmark	
	domain = @values[row_index]
	if column == 0 then
	  
	  if @config.domain_enabled?(domain.module_name) 
	    return '✓'
	  else
	    return ' '
	  end
	
	end
	
	if column == 1 then
	  return domain.module_name
	end
	
  end

end