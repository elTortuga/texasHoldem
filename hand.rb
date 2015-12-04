require 'card'

class Hand

  attr_accessor :cards, :ranking, :first_high_card, :second_high_card, :third_high_card

  def initialize(cards, ranking, first_high_card, second_high_card, third_high_card)
    @cards = cards
    @ranking = ranking
    @first_high_card = first_high_card
    @second_high_card = second_high_card
    @third_high_card = third_high_card
  end
  
end