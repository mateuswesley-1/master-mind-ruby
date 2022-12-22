require 'pry-byebug'
class MasterMind
  def initialize
    @codigo = Array.new(4) { rand(1..6) }.join
    @turn = 1
    @game_on = true
  end

  # print the user guess and the clues
  def print_feedback
    p @guess
    puts ''
    puts "#{clues[:number_right]} Right Numbers in the Wrong Position "
    puts "#{clues[:position_right]} Right Numbers in the Right Position "
    puts ''
  end

  def get_guess
    while true
      puts "Turn #{@turn}: Type in four numbers (1..6) to guess the code. Or `q` if you want to leave"
      code = gets.chomp.strip.downcase

      # if first is true, second is returned.
      if code == 'q'
        @game_on = false
        return false
      end

      @guess = code

      if validate_guess
        break
      else
        continue
      end
    end
  end

  def validate_guess
    begin
      Integer(@guess)
    rescue ArgumentError
      return false
    end

    false unless @guess.length != 4
    true
  end

  def clues
    @position_right = 0
    @number_right = 0
    @guess.split('').each_with_index do |number, index|
      if number == @codigo[index]
        @position_right += 1
      elsif @codigo.include? number
        @number_right += 1
      end
    end
    { number_right: @number_right, position_right: @position_right }
  end

  # A round of the game, the max number of round is 12
  def round
    get_guess
    @turn += 1
  end

  def check_result
    if clues[:position_right] == 4
      @game_on = false
      puts 'Parabens! Voce acertou.'
    end

    if @turn > 5
      @game_on = false
      puts 'Mais sorte na proxima vez.'
    end
  end

  def game
    while @game_on == true
      round
      print_feedback
      check_result
    end
  end
end
master_mind = MasterMind.new
master_mind.game


