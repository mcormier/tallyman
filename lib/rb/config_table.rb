class ConfigTable < PPCurses::TableView
  
  SPACE_BAR = ' '

  def initialize(config) 
    super()
	@config = config
  end

  def key_down( key )
    super(key)
	

  	if key == SPACE_BAR
	  
	    title = @data_source.object_value_for(self,1,@selected_row)
	    if @config.domain_enabled?(title)
	      @config.disable_domain(title)
      else
	      @config.enable_domain(title)
	    end
	  
	  end
    
  end


end

class DomainDataSource < PPCurses::MultipleColumnDataSource

  attr_accessor :values

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