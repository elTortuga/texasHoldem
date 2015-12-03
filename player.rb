class Player
  attr_accessor :hand, :pocket, :name, :tokens, :is_turn

  def initialize(name, tokens)
    @name = name
    @tokens = tokens
    @pocket = []
  end



########################### Utility ###########################
  def to_s
    print @name + ' ' + @tokens.to_s + ' '
    if @pocket.any?
      print @pocket[0].to_s + ' ' + @pocket[1].to_s
    end
  end

end