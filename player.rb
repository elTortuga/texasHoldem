require_relative 'rankingUtility'
require_relative 'hand'

class Player
  attr_accessor :hand, :pocket, :name, :chips, :is_turn, :folded, :player_ID

  def initialize(name, tokens)
    @name = name
    @chips = chips
    @pocket = []
    @folded = false
  end

  def set_hand(table_cards)
    @hand = Hand.new(RankingUtility.get_merged_cards(@pocket, table_cards)
  end

########################### Utility ###########################
  def to_s
    print @name + ' ' + @chips.to_s + ' '
    if @pocket.any?
      print @pocket[0].to_s + ' ' + @pocket[1].to_s
    end
  end
end