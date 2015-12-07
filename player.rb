require_relative 'rankingUtility'
require_relative 'hand'

class Player
  attr_accessor :hand, :pocket, :name, :chips, :is_turn, :folded, :player_ID

  def initialize(name, chips, player_ID)
    @name = name
    @chips = chips
    @player_ID = player_ID
    @pocket = []
    @folded = false
    @rankingUtility = RankingUtility.new
  end

  def set_hand(table_cards)
    cards = @rankingUtility.get_merged_cards(@pocket, table_cards)
    # print @name.to_s + ' '
    # @rankingUtility.print_cards(cards)
    @hand = @rankingUtility.get_hand(cards)
    # @hand.to_s
  end

########################### Utility ###########################
  def to_s
    print @name + ' ' + @chips.to_s + ' '
    if @pocket.any?
      print @pocket[0].to_s + ' ' + @pocket[1].to_s
    end
  end
end

# rankingUtility = RankingUtility.new
# cards = []

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qc"))
# cards.push(Card.new("Js"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("4h"))
# cards.push(Card.new("2h"))
# rankingUtility.print_cards(cards)
# cards = rankingUtility.get_merged_cards(cards, cards)
# print cards
# rankingUtility.print_cards(cards)
# puts