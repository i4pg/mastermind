# frozen_string_literal: false

# mastermind game
module Codes
  attr_accessor :code_colors

  @@code_colors = %w[red green blue orange pink yellow]
end

class NewGame
  include Codes
  attr_accessor :secret_code

  def initialize
    @@secret_code = Array.new(4)
  end
end

class PlayerCreator < NewGame
  def player_creator
    puts @@code_colors
    puts 'Choose colors then Enter Your Secret Code sperated by space'
    code = gets.chomp
    @@secret_code = code.downcase.split
  end
end

class ComputerCreator < NewGame
  def computer_code
    @@secret_code.each_with_index do |_color, index|
      randomize = @@code_colors.sample

      @@secret_code[index] = randomize
    end
  end
end

class ComputerGuesser < PlayerCreator
  def initialize
    PlayerCreator.new
    player_creator
  end

  def guessing(result = [], guess = [], tries = 1)
    loop do
      sleep(1)
      break if tries == 8 || guess == @@secret_code || result == @secret_code

      @@secret_code.each_with_index do |_color, index|
        randomize = @@code_colors.sample
        next if result[index] == randomize

        guess[index] = randomize
      end

      puts ''
      puts "Computer #{tries} guess is #{guess}"
      tries += 1
      puts ''

      guess.each_with_index do |element, index|
        next unless element == @@secret_code[index]

        result[index] = element
        puts "Computer has found #{element} correct"
      end
    end
    puts "Computer final result is #{result}"
    if result == @@secret_code
      puts "Can't beat AI ha ? LOL"
    else
      puts 'You defeat the AI, Congrats!'
    end
  end
end

class PlayerGuesser < ComputerCreator
  def initialize
    ComputerCreator.new
    computer_code
    @round = 7
  end

  def try
    guess = ''
    puts @@secret_code
    puts 'Enter the code using downcase charctars and spaces'
    puts 'ex. blue green orange red'

    loop do
      break if guess.downcase.split == @@secret_code || @round <= 0

      correct = 0
      swipe = 0
      puts ''
      puts 'Enter your guessing code?'
      guess = gets.chomp
      puts ''
      guess.downcase.split.each_with_index do |element, index|
        if element == @@secret_code[index]
          correct += 1
        elsif element == @@secret_code[index - 1] || element == @@secret_code[index + 1]
          swipe += 1
        end
      end
      puts "You Got only #{correct} correct guess/es, you can do it!" if correct.positive? && correct < 4
      puts 'Try To swipe between' if swipe.positive?
      @round -= 1
      if @round.zero?
        puts 'Sorry, You are out of chance!'
      elsif guess.downcase.split == @@secret_code
        puts 'And you guessed it! Amazing!'
      else
        puts "you still got #{@round} guessing more, Try again!"
      end
    end
  end
end

def new_game
  puts 'Choose mode, 1 & 2'
  puts '1. You Guesser'
  puts '2. Computer Guesser'
  mode = gets.chomp.to_i
  if mode == 1
    master_mind = PlayerGuesser.new
    master_mind.try
  elsif mode == 2
    master_mind = ComputerGuesser.new
    master_mind.guessing
  else
    puts 'Wrong input! Choose 1 & 2'
    new_game
  end
end

new_game
