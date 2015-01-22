class FuelAction

  attr_accessor :form

  def initialize
    @form = PPCurses::Form.new


    unit_price = PPCurses::InputElement.new_integer_only(' Unit Price', 5)
    cost = PPCurses::InputElement.new_integer_only(' Cost', 5)

    # TODO -- add a date picker here ...

    @form.add(unit_price)
    @form.add(cost)

  end


end