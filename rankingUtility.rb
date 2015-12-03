require_relative 'card'

class RankingUtility
  NUMBER_OF_CARDS_IN_HAND = 5

  HAND_NAMES = {
    'ROYAL_FLUSH'     => 10,
    'STRAIGHT_FLUSH'  => 9,
    'FOUR_OF_A_KIND'  => 8,
    'FULL_HOUSE'      => 7,
    'FLUSH'           => 6,
    'STRAIGHT'        => 5,
    'THREE_OF_A_KIND' => 4,
    'TWO_PAIR'        => 3,
    'ONE_PAIR'        => 2,
    'HIGH_CARD'       => 1
  }

############################## hands #################################

  def get_royal_flush(cards)
    collection_of_cards_by_suit = break_into_collection_of_same_suit(cards)
    collection_of_cards_by_suit.each do |suit_collection|
      if suit_collection != []
        if suit_collection[0].face_value == Card::FACE_VALUES['A'] && suit_collection[1].face_value == Card::FACE_VALUES['K'] && suit_collection[2].face_value == Card::FACE_VALUES['Q'] && suit_collection[3].face_value == Card::FACE_VALUES['J'] && suit_collection[4].face_value == Card::FACE_VALUES['0']
          return suit_collection, HAND_NAMES['ROYAL_FLUSH']
        end
      end
    end
    nil
  end

  def get_straight_flush(cards)
    collection_of_cards_by_suit = break_into_collection_of_same_suit(cards)
    collection_of_cards_by_suit.each do |suit_collection|
      unless suit_collection == []
        unless get_straight(suit_collection) == nil
          cards, name, high_card = get_straight(suit_collection) # FIX correctly gather only the cards from the returned tuple
          return cards, HAND_NAMES['STRAIGHT_FLUSH'], cards[0] 
        end
      end
    end
    nil
  end

  def get_four_of_a_kind(cards)
    four_cards = []
    set_by_faces = break_into_collection_of_same_face(cards)
    set_by_faces.each do |set|
      if set.count == 4
        four_cards = set
        set_by_faces.delete(set)
      end
    end
    unless four_cards == []
      high_card = []
      high_card.push(set_by_faces.at(0).at(0))
      cards = get_merged_cards(four_cards, high_card)
      four_of_a_kind_high_card = four_cards[0]
      return cards, HAND_NAMES['FOUR_OF_A_KIND'], four_of_a_kind_high_card, high_card[0]
    end
    return nil
  end

  def get_full_house
  end

  def get_flush
  end

#Get straight returns the cards belonging to the hand, the value of the hand, and the high card.
#The input must be a collection of 5 cards with non repeating face values, this requires the cards to be filterd before being passed to this method.
  def get_straight(cards)
    if cards.count < NUMBER_OF_CARDS_IN_HAND
      return nil
    end
    index = 0
    while index < cards.count-1
      if (cards.at(index).face_value - cards.at(index+1).face_value) != 1
        return nil
      end
      index += 1
    end
    index = cards.count - NUMBER_OF_CARDS_IN_HAND
    while index > 0
      cards.pop
      index -= 1
    end
    return cards, HAND_NAMES['STRAIGHT'], cards[0] #cards, hand's value, high card
  end

  def get_three_of_a_kind
  end

  def get_two_pair(cards)
    first_pair = []
    second_pair = []
    cards = order_cards_by_face(cards)
    
    if get_pair(cards) == nil
      return nil
    end
    returned_get_pair, delete, first_pair_high_card, delete = get_pair(cards)
    first_pair = returned_get_pair[0..1]
    cards = (remove_cards_from_collection(first_pair, cards))

    if get_pair(cards) == nil
      return nil
    end
    returned_get_pair, delete, second_pair_high_card, delete = get_pair(cards)
    second_pair = returned_get_pair[0..1]
    cards = (remove_cards_from_collection(second_pair, cards))

    delete , delete, high_card = get_high_card(cards)
    cards = get_merged_cards(first_pair, second_pair)
    cards.push(high_card)
    return cards, HAND_NAMES['TWO_PAIR'], first_pair_high_card, second_pair_high_card, high_card
    
  end

  def get_pair(cards)
    cards = order_cards_by_face(cards)
    pair = []
    index = 0
    found = false
    while (index < cards.count - 1) && found != true 
      # print cards.at(index). == cards.at(index+1)
      if cards.at(index).face_value == cards.at(index+1).face_value
        pair.push(cards.at(index))
        pair.push(cards.at(index+1))
        found = true
      end
      index += 1
    end
    if found == false
      return nil
    end
    cards = remove_cards_from_collection(pair, cards)
    cards = cards[0..2]
    delete, delete, high_card = get_high_card(cards) # FIX handle tuples correctly
    pair_high_card = pair.at(0)
    cards = get_merged_cards(pair, cards)
    return cards, HAND_NAMES['ONE_PAIR'], pair_high_card, high_card # cards, hand's value, high card of the pair, high card outside the pair 
  end

  def get_high_card(cards)
    high_card = order_cards_by_face(cards).at(0)
    cards = cards[0..-3]
    return cards, HAND_NAMES['HIGH_CARD'], high_card
  end

########################## Helpers #####################################

  def remove_cards_from_collection(cards_to_remove, cards)
    cards_to_remove.each do |card|
      cards = remove_card_from_collection(card, cards)
    end
    cards
  end

  def remove_card_from_collection(card_to_remove, cards)
    cards.each do |card|
      if card == card_to_remove
        cards.delete(card)
      end
    end
    cards
  end

  def isSameSuit?(cards)
    cards = order_cards_by_suit(cards)
    suit_value = cards[0].suit_lookup
    count = 0
    cards[1..-1].each do |card|
      if suit_value == card.suit_lookup
        count += 1
      else
        suit_value = card.suit_lookup
        count = 0
      end
      if count == 4
        return true
      end
    end
    return false
  end

  def break_into_collection_of_same_suit(cards)
    collection_of_cards_by_suit = [[], [], [], []]
    cards = order_cards_by_suit(cards)
    cards.each do |card|
      case card.suit_lookup
      when Card::SUIT_LOOKUP['c']
        collection_of_cards_by_suit[0].push(card)
      when Card::SUIT_LOOKUP['d']
        collection_of_cards_by_suit[1].push(card)
      when Card::SUIT_LOOKUP['h']
        collection_of_cards_by_suit[2].push(card)
      when Card::SUIT_LOOKUP['s']
        collection_of_cards_by_suit[3].push(card)
      end
    end
    collection_of_cards_by_suit
  end

  def break_into_collection_of_same_face(cards)
    collection_of_cards_by_face = []
    cards = order_cards_by_face(cards)
    cards.each do |card|
      if collection_of_cards_by_face == []
        collection_of_cards_by_face.push([card])
      else
        index = 0
        exit = false
        while (index < collection_of_cards_by_face.count) && (exit == false)
          if collection_of_cards_by_face.at(index).at(0).face_value == card.face_value
            collection_of_cards_by_face.at(index).push(card)
            exit = true
          end
          index += 1
        end
        unless exit == true
          collection_of_cards_by_face.push([card])
        end
      end
    end
    return collection_of_cards_by_face      
  end

  def break_into_sets_of_five_cards(cards)
    sets_of_five_cards = []
    index = 0
    while index + NUMBER_OF_CARDS_IN_HAND <= cards.count
      sets_of_five_cards.push(cards[index..(index+NUMBER_OF_CARDS_IN_HAND-1)])
      index += 1
    end
    return sets_of_five_cards
  end

  def check_for_ace_and_add_low_ace
  end

  def get_merged_pocket_and_table(pocket_cards, table_cards)
    merged_cards = []
    table_cards.each do |card|
      merged_cards.push(card)
    end
    pocket_cards.each do |card|
      merged_cards.push(card)
    end
    merged_cards
  end

  def get_merged_cards(cards1, cards2)
    merged_cards = []
    cards1.each do |card|
      merged_cards.push(card)
    end
    cards2.each do |card|
      merged_cards.push(card)
    end
    merged_cards
  end

  def order_cards_by_suit(cards)
    cards.sort_by { |card| [card.suit_lookup, card.face_value] }.reverse
  end

  def order_cards_by_face(cards)
    cards.sort_by { |card| [card.face_value, card.suit_lookup] }.reverse
  end

  ######################### For debuging ###############################
    def print_cards(cards)
    cards.each do |card|
      print card.to_s + ' '
    end
    puts ''
  end

end

rankingUtility = RankingUtility.new
cards = []
########################## Royal Flush ############################## checked

# cards.clear
# cards.push(Card.new("Ah"))
# cards.push(Card.new("Kd"))
# cards.push(Card.new("Qd"))
# cards.push(Card.new("Js"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_royal_flush(cards))
# puts ''

# cards.clear
# cards.push(Card.new("Ah"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("Jh"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9d"))
# cards.push(Card.new("8d"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_royal_flush(cards))
# puts ''

######################### Straight Flush ############################# checked

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("Jh"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_straight_flush(cards))
# puts ''

######################### Four Of A Kind ############################# checked

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("Jh"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_four_of_a_kind(cards))
# puts ''

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("8d"))
# cards.push(Card.new("8s"))
# cards.push(Card.new("8c"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_four_of_a_kind(cards))
# puts ''

######################### Get Two Pair ############################# checked

cards.clear
cards.push(Card.new("2d"))
cards.push(Card.new("Kh"))
cards.push(Card.new("Qh"))
cards.push(Card.new("Jh"))
cards.push(Card.new("8c"))
cards.push(Card.new("2h"))
cards.push(Card.new("8h"))
rankingUtility.print_cards(cards)
print (rankingUtility.get_two_pair(cards))
cards, delete, delete, delete, delete = rankingUtility.get_two_pair(cards)
puts ''
rankingUtility.print_cards(cards)
puts ''

######################### Get Pair ############################# checked

# cards.clear
# cards.push(Card.new("2d"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("Jh"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("2h"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_pair(cards))
# puts ''

######################### Get High Card ############################# checked

# cards.clear
# cards.push(Card.new("2d"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("Jh"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_high_card(cards))
# puts ''

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qh"))
# cards.push(Card.new("8d"))
# cards.push(Card.new("8s"))
# cards.push(Card.new("8c"))
# cards.push(Card.new("8h"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.get_high_card(cards))
# puts ''

######################### Straight ############################# checked

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Kh"))
# cards.push(Card.new("Qc"))
# cards.push(Card.new("Js"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("9h"))
# cards.push(Card.new("5h"))
# cards.push(Card.new("4h"))
# cards.push(Card.new("3h"))
# cards.push(Card.new("2h"))
# cards.push(Card.new("Lh"))
# rankingUtility.print_cards(cards)
# sets_of_five = rankingUtility.break_into_sets_of_five_cards(cards)
# sets_of_five.each do |c|
#   print (rankingUtility.get_straight(c))
# end
# puts ''

######################### Break into Sets by Face Value ############################# checked

# cards.clear
# cards.push(Card.new("Ad"))
# cards.push(Card.new("Ac"))
# cards.push(Card.new("Qc"))
# cards.push(Card.new("0s"))
# cards.push(Card.new("0h"))
# cards.push(Card.new("0c"))
# cards.push(Card.new("5h"))
# cards.push(Card.new("4h"))
# cards.push(Card.new("3h"))
# cards.push(Card.new("3c"))
# cards.push(Card.new("Lh"))
# rankingUtility.print_cards(cards)
# print (rankingUtility.break_into_collection_of_same_face(cards))
# puts ''

