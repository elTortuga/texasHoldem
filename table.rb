require_relative 'deck'
require_relative 'player'
require_relative 'rankingUtility'

class Table
  attr_accessor :table_number, :deck, :table_cards, :players, :rankingUtility

  def initialize(players, table_number)
    @players = []
    players.each do |player|
      @players.push(Player.new(player[0], player[1]))
    end
    @table_number = table_number

    @deck = Deck.new
    @deck.shuffle
    @table_cards = []
    @rankingUtility = RankingUtility.new


  end

  def add_player(player)
    @players.push(player)
  end

  def remove_player_by_name(player_name)
    @players.delete_if {|player| player.name == player_name}
  end

  ########################### Dealing ########################

  def deal_pockets
    @players.each do |player|
      player.pocket = [@deck.deal, @deck.deal]
    end
  end

  def call_flop
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
    @table_cards.push(@deck.deal)
    @table_cards.push(@deck.deal)
  end

  def bet_turn
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
  end

  def bet_river
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
  end

  ########################### return winner ######################

  def get_winner
    winners = []

    players.each do | player | #remove folded players from
      winners.push(player) if player.folded == false
    end

    index = 0
    while (index < winners.count)
      if winners.at(index).hand.ranking > winners.at(index+1).hand.ranking
        winners.delete(winners.at(index+1))
      end
    end


    end

    # if winners.count == 0 #all players fold?
    #   return nil
    # end

  end


  ########################### Utilities ######################

  def print_players_info
    @players.each do |player|
      player.to_s
      puts ''
    end
    puts ''
  end

  def print_cards (cards)
    cards.each do |card|
      print card.to_s + ' '
    end
    puts ''
  end
end

list_of_players = [["bob", 500],["joe", 500], ["megan", 500], ["sam", 500]]

table = Table.new(list_of_players, 123)
table.print_players_info
table.add_player(Player.new("travis", 500))
table.print_players_info
table.remove_player_by_name("bob")
table.print_players_info
table.deal_pockets
table.print_players_info

table.call_flop
table.bet_turn
table.bet_river

table.print_cards(table.table_cards)

cards = table.rankingUtility.get_merged_pocket_and_table(table.players[0].pocket, table.table_cards)
table.print_cards(cards)
cards = table.rankingUtility.order_cards_by_suit(cards)
table.print_cards(cards)
cards = table.rankingUtility.order_cards_by_face(cards)
table.print_cards(cards)