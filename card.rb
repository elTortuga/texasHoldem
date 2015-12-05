class Card
  attr_reader :suit, :face
  SUITS = "cdhs"
  FACES = "L234567890JQKA"
  SUIT_LOOKUP = {
    'c' => 0,
    'd' => 1,
    'h' => 2,
    's' => 3,
    'C' => 0,
    'D' => 1,
    'H' => 2,
    'S' => 3  
  }
  FACE_VALUES = {
    'L' =>  1,   # this is a magic low ace
    '2' =>  2,
    '3' =>  3,
    '4' =>  4,
    '5' =>  5,
    '6' =>  6,
    '7' =>  7,
    '8' =>  8,
    '9' =>  9,
    '0' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }

  def initialize(string_representation)
    @face = string_representation[0]
    @suit = string_representation[1]
  end

  def face_value
    FACE_VALUES[@face]
  end

  def suit_lookup
    SUIT_LOOKUP[@suit]
  end

  def to_s
     @face + @suit
  end
  
end