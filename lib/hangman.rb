class Hangman

  def initialize(dictionary_name)
    if File.exist?(dictionary_name)
      contents = File.read(dictionary_name)
      @dictionary = contents.split("\n")
      # for now we only want words between a length
      # of 5 and 12.
      @dictionary.filter! { |word| word.length > 4 && word.length < 13 }
    end
    @guesses = []
    @lives = 6
    puts "Let's Play Hangman!"
    play
  end

  def play
    choose_word
    until game_over? || game_won?
      print_game
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
    #TODO, show previous guesses, revealed word, remaining wrong guesses
    puts "Remaining Lives: #{@lives}"
    puts "Current word: #{@revealed_word}"
    puts "Previous Guesses: #{@guesses}"
  end

  def prompt_guess
    guess = ''
    until guess.length == 1 && guess.match?(/[a-z]/) && !@guesses.include?(guess)
      puts 'Enter a letter to guess (that hasn\'t already been guessed.)'
      guess = gets.chomp.downcase
    end
    @guesses.push(guess)
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
end

Hangman.new('google-10000-english-no-swears.txt')
