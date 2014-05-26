def say(msg)
  puts "
  >>> #{msg} <<<
  "
end

#//////////////////Cards/////////////////////

class Card
  attr_accessor :value
  attr_reader :name, :suit

  def initialize(name, suit, value)
    @name=name
    @suit=suit
    @value=value
  end
end

#//////////////////Deck/////////////////////

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
    values_names = [['Ace',11], ['King',10], ['Queen',10], ['Jack',10], [10], [9], [8], [7], [6], [5], [4], [3], [2]]
    suits.each do |suit|
      values_names.each do |vals|
        @cards.push(Card.new(vals[0], suit, vals.last))
      end
    end
    @cards = @cards.shuffle
  end
end

#//////////////////Player/////////////////////

class Player
  BLACKJACK_AMOUNT = 21
  attr_reader :info

  def initialize(player="The Dealer")
    @info={name:player, cards: []}
  end

#///////

  def value_of_hand
    value = 0
    info[:cards].each do |a|
      value += a.value.to_i
    end
    return value
  end

#///////

  def show_all_cards
    info[:cards].each do |a|
      sleep(1)
      puts "#{info[:name]} currently holds the #{a.name} of #{a.suit}"
    end
  end

#///////

  def ace_count
    count = 0
    info[:cards].each do |a|
      if a.name == 'Ace'
        count+=1
      end
    end
    return count
  end

#///////

  def ace_to_one
    info[:cards].each do |a|
      if (a.name == 'Ace' && a.value == 11)
        a.value=(1)
        break
      end
    end
  end

#///////

  def dealing_with_aces
    i = 0
    until i == ace_count
      say("You have an Ace so you can re-choose the value! Would you like to value it as an 11 or as a 1? Type an '11' or '1'")
      while ace = gets.chomp
        if ace == "11"
          i+=1
          break
        elsif ace == "1"
          ace_to_one
          i+=1
          break
        else
          say("C'mon #{info[:name]}! Invalid Response: Please choose '11' or '1'")
        end
      end
    end
  end

#///////

  def bust?
    if self.value_of_hand > BLACKJACK_AMOUNT
      true
    else
      false
    end
  end
#///////
end

#//////////////////Dealer/////////////////////

class Dealer < Player
  def show_dealer_cards
    info[:cards].each_with_index do |a, index|
      if index == 0
        next
      end
      sleep(1)
      puts "#{info[:name]} currently holds the #{a.name} of #{a.suit}"
    end
  end
end

#//////////////////GAME_Play/////////////////////

class Game
  attr_accessor :live_deck, :dealer, :players, :gambler
  MIN_DEALER_HIT = 17

  def initialize
    @live_deck
    @dealer = Dealer.new
    @players = []
    @players<<@dealer
    @gambler
  end

#///////

  def introduction
    puts "------Hi! Lets play BlackJack!------"
    say("Please enter your name")
    self.gambler = Player.new(gets.chomp)
    players.unshift(self.gambler)
    say("Hi #{self.gambler.info[:name]}! I hope you're ready to lose some money. I'm dealing!")
  end

  #///////

  def first_deal
    @live_deck = Deck.new
    i = 0
    while i < self.players.length
      self.players.each do |a|
        a.info[:cards]<<live_deck.cards.pop
      end
      i+=1
    end
  end

#///////

  def show_cards_during_game
    self.gambler.show_all_cards
    self.dealer.show_dealer_cards
    self.gambler.dealing_with_aces
  end

#///////

  def show_cards_end_game
    puts
    puts "The final cards are:"
    puts
    self.gambler.show_all_cards
    self.dealer.show_all_cards
  end

#///////

  def hit_or_stay
    say("Would you like to Hit or Stay? Type 'H' or 'S' until you have finalized your hand!")
    while hit = gets.chomp
      if hit == "H" || hit == "h"
        self.gambler.info[:cards]<<live_deck.cards.pop
        self.gambler.show_all_cards
        self.gambler.dealing_with_aces
        if self.gambler.bust?
          break
        else
          say("Hit Again????? #{self.gambler.info[:name]}, you prolly should. Type 'H' or 'S'")
        end
      elsif hit == "S" || hit == "s"
        break
      else
        say("C'mon #{self.gambler.info[:name]}! Invalid Response: Please choose 'H' or 'S'")
      end
    end
  end
#///////
  def dealer_gamplay
    if self.gambler.bust? == false
      while self.dealer.value_of_hand < MIN_DEALER_HIT
        self.dealer.info[:cards]<<live_deck.cards.pop
      end
    end
  end

#///////

  def final_message
    puts
    puts "---------------------------------------------------"
    puts
    sleep(1)
    if self.gambler.bust?
      puts("----You have #{self.gambler.value_of_hand}----")
      say("FUUUUUUUUUUUUUUUU #{self.gambler.info[:name]}, YOU BUSTED! I'm not surprised")
    elsif self.dealer.bust?
      self.show_cards_end_game
      puts("----You have #{self.gambler.value_of_hand}, The Dealer has #{self.dealer.value_of_hand}----")
      say("The Dealer Busted, You WINNNNNNNNNNN")
    elsif self.gambler.value_of_hand > self.dealer.value_of_hand
      self.show_cards_end_game
      puts("----You have #{self.gambler.value_of_hand}, The Dealer has #{self.dealer.value_of_hand}----")
      say("YOU WIN!!!!!!!!!!!!!! You win nothing because I haven't added betting functionality to this program.")
    else
      self.show_cards_end_game
      puts("----You have #{self.gambler.value_of_hand}, The Dealer has #{self.dealer.value_of_hand}----")
      say("You LOSSSSSEEEEEEEEEEEEEE")
    end
  end

#///////

  def clear_hands
    i = 0
    while i < self.players.length
      self.players.each do |a|
        a.info[:cards].clear
      end
      i+=1
    end
  end

#///////

  def run
    self.introduction
    play_game = 0
    while play_game == 0
      puts
      puts "---------------------------------------------------"
      puts
      self.first_deal
      self.show_cards_during_game
      self.hit_or_stay
      self.dealer_gamplay
      self.final_message
      self.clear_hands
    say("Would you like to play again? 'Y' or 'N'")
      while play = gets.chomp
        if play == "Y" || play == "y"
          break
        elsif play == "N" || play == "n"
          play_game+=1
        break
        else
          say("Invalid Repsonse - Please type 'Y' or 'N'")
        end
      end
    end

  end

end

game = Game.new
game.run