require_relative 'card'
# require_relative 'rankingUtility' #This is a no no and I don't know why...

class Hand

  attr_accessor :cards, :ranking, :first_high_card, :second_high_card, :third_high_card

  def initialize(cards, ranking, first_high_card, second_high_card, third_high_card)
    @cards = cards
    @ranking = ranking
    @first_high_card = first_high_card
    @second_high_card = second_high_card
    @third_high_card = third_high_card
  end

  def to_s
    print "Cards:     "
    print_cards(@cards)
    puts "Hand Rank: " + @ranking.to_s  + ", First High Card: " + @first_high_card.to_s + ", Second High Card: " + second_high_card.to_s + ", Third High Card: " + third_high_card.to_s
  end

  def print_cards(cards)
    if(cards == nil)
      puts "Cards are empty"
      return
    end
    cards.each do |card|
      print card.to_s + ' '
    end
    puts ''
  end
end