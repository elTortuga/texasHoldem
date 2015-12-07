require_relative 'deck'
require_relative 'player'
require_relative 'rankingUtility'

class Table
  attr_accessor :table_ID, :deck, :table_cards, :players, :rankingUtility, :winners

  def initialize(players, table_ID)
    @players = []
    players.each do |player|
      @players.push(Player.new(player[0], player[1], player[2]))
    end
    @winners = []
    
    @table_ID = table_ID
    @deck = Deck.new
    @deck.shuffle
    @table_cards = []
    @rankingUtility = RankingUtility.new

    # deal_pockets
    # call_flop
    # bet_turn
    # bet_river

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

  # Get user input

  def call_flop
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
    @table_cards.push(@deck.deal)
    @table_cards.push(@deck.deal)
  end

  # Get user input

  def bet_turn
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
  end

  # Get user input

  def bet_river
    @deck.deal #burn card
    @table_cards.push(@deck.deal)
  end

  # Get user input

  ########################### return winner ######################

  def get_winner
    winners = []

    @players.each do | player | #remove folded players from
      winners.push(player) if player.folded == false
    end

    # puts winners
    # puts winners[0].hand

    index = 0
    while index < winners.count - 1
      # puts winners[index].hand
      if winners[index].hand.ranking > winners[index+1].hand.ranking
        winners.delete(winners[index+1])
      elsif winners[index].hand.ranking < winners[index+1].hand.ranking
        winners.delete(winners[index])
      else
        ##check first then second then third highcard
        index += 1
      end
    end

    @winners = winners
  end

  ########################### Utilities ######################


  def print_players_info(players)
    players.each do |player|
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

list_of_players = [["bob", 500, 1],["joe", 500, 2], ["megan", 500, 3], ["sam", 500, 4], ["billy", 500, 6], ["mack", 500, 7]]

table = Table.new(list_of_players, 123)
table.print_players_info(table.players)
table.add_player(Player.new("travis", 500, 5))
table.print_players_info(table.players)
table.remove_player_by_name("bob")
table.print_players_info((table.players))
table.deal_pockets
table.print_players_info((table.players))

table.call_flop
table.bet_turn
table.bet_river

print "Table Cards: "
table.print_cards(table.table_cards)
puts

# cards = table.rankingUtility.get_merged_pocket_and_table(table.players[0].pocket, table.table_cards)
# table.print_cards(cards)
# cards = table.rankingUtility.order_cards_by_suit(cards)
# table.print_cards(cards)
# cards = table.rankingUtility.order_cards_by_face(cards)
# table.print_cards(cards)

# Testing the functionality of set_hand in players, Hand initilization, and get_hand in RankingUtility
table.players.each do |player|
  puts player.name
  player.set_hand(table.table_cards)
  player.hand.to_s
  puts
end

table.get_winner
table.print_players_info(table.winners)