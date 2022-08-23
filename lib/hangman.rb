require 'yaml'

class Hangman
  @save_file_name = 'hangman.yaml'

  def self.save_file_name
    @save_file_name
  end

  def initialize(dictionary_name)
    if load_game?
      load_game
    else
      start_new_game(dictionary_name)
    end
    puts "Let's Play Hangman!"
    
    play
  end

  def play
    until game_over? || game_won?
      print_game
      puts 'Do you want to save? (type \'y\' if you want to)'
      save_game if gets.chomp.downcase == 'y'
      guess = prompt_guess
      check_guess(guess)
    end
    game_won? ? show_win_screen : show_loss_screen
  end

  def choose_word
    @word = @dictionary.sample
    @revealed_word = '_' * @word.length
  end

  def print_game
    puts "Remaining Lives: #{@lives}"
    puts "Current word: #{@revealed_word}"
    puts "Previous Guesses: #{@guesses}"
  end

  def prompt_guess
    guess = ''
    puts 'Enter a letter to guess'
    until guess.length == 1 && guess.match?(/[a-z]/) && !@guesses.include?(guess)
      puts 'make sure it hasn\'t already been guessed,and that it\'s a valid character between a and z'
      guess = gets.chomp.downcase
    end
    puts "#{guess} is present in the word!"
    @guesses.push(guess).sort!
    guess
  end

  def check_guess(guess)
    if @word.include?(guess)
      @word.each_char.each_with_index { |letter, idx| @revealed_word[idx] = letter if letter == guess }
    else
      @lives -= 1
    end
  end

  def game_over?
    @lives.zero?
  end

  def game_won?
    @revealed_word == @word
  end

  def show_win_screen
    puts 'YOU WIN! Great job!'
  end

  def show_loss_screen
    puts 'GAME OVER! Sorry, you ran out of lives'
  end

  def save_game
    game_state = { word: @word, guesses: @guesses, lives: @lives, revealed_word: @revealed_word }
    file = File.open(self.class.save_file_name, 'w+')
    YAML.dump(game_state, file)
  end

  def load_game?
    puts 'Would you like to load game, or start a new game?'
    puts 'L for load, Q to close, anything else to start'
    input = gets.chomp.upcase
    exit if input == 'Q'
    input == 'L'
  end

  def load_game
    file = File.open(self.class.save_file_name, 'r')
    game_state = YAML.load(file)
    @word = game_state[:word]
    @guesses = game_state[:guesses]
    @lives = game_state[:lives]
    @revealed_word = game_state[:revealed_word]
  end

  def start_new_game(dictionary_name)
    if File.exist?(dictionary_name)
      contents = File.read(dictionary_name)
      @dictionary = contents.split("\n")
      # for now we only want words between a length
      # of 5 and 12.
      @dictionary.filter! { |word| word.length > 4 && word.length < 13 }
    end
    @guesses = []
    @lives = 6
    choose_word
  end
end

Hangman.new('google-10000-english-no-swears.txt')
