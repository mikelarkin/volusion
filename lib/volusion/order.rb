module Volusion
  class Order
    attr_accessor :id, :first_name, :last_name, :email, :line_items, :status

    def initialize(id, first_name, last_name, email, line_items, status)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @email = email
      @line_items = line_items                                         
		@status = status
    end

  end
end
