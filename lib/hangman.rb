
class Hangman
  @dictionary = []
  @word = nil
  @revealed_word = nil
  @guesses = []

  def initialize(dictionary_name)
    if File.exist?(dictionary_name)
      contents = File.read(dictionary_name)
      @dictionary = contents.split("\n")
      # for now we only want words between a length
      # of 5 and 12.
      @dictionary.filter! { |word| word.length > 4 && word.length < 13 }
    end

    puts "Let's Play Hangman!"
    play
  end

  def play
    choose_word
    until game_over?
      print_game
      guess = prompt_guess
      check_guess(guess)
    end
  end

  def choose_word
    @word = @dictionary.sample
    @revealed_word = @word.map { |letter| '_'}
  end

  def print_game
    #TODO
    ''
  end

  def prompt_guess
    guess = ''
    until guess.length == 1 && guess.match?(/[a-z]/) && !@guesses.include?(guess)
      puts 'Enter a letter to guess (that hasn\'t already been guessed.)'
      guess = gets.chomp.downcase
    end
    @guesses = @guesses.push(guess)
    guess
  end

  def check_guess(guess)
    word.each_with_index { |letter, idx| @revealed_word[idx] = letter if letter == guess} if word.include?(guess)
  end
end

Hangman.new('google-10000-english-no-swears.txt')
