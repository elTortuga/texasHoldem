require_relative 'card'

class Deck

  def initialize
    @cards = []
    Card::SUITS.split("").each do |suit|
      Card::FACES[1..-1].split("").each do |face| #FACES[1..-1] avoids double ace's in the deck
        # puts face + suit + ' ' + Card.new(face + suit).to_s + ' ' + Card.new(face + suit).face_value.to_s + ' ' + Card.new(face + suit).suit_lookup.to_s # For testing purposes MR MEESEEKS
        @cards.push(Card.new(face + suit))
      end
    end
  end

  def shuffle
    @cards = @cards.shuffle
    # @cards.each do |card|  #Yes this works
    #   puts card
    # end
  end

  def deal
    @cards.pop
  end
end

# deck = Deck.new
# deck.shuffle

# puts deck.deal