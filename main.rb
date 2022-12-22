class MasterMind
  # Mastermind Game Class
  def initialize
    @code = Array.new(4) { rand(1..6) }.join
    @turn = 1
    @game_on = true
  end

  def game
    create_players

    read_code_human if @person.breaker.zero?

    while @game_on == true
      round
      print_feedback
      check_result
    end
  end

  def round
    if @person.breaker == 1
      read_guess_human
      @turn += 1
    end

    return unless @person.breaker.zero?

    read_guess_pc
    @turn += 1


  end

  def set_up_game
    print 'Welcome to the game!'
    create_players
  end

  def create_players
    user = read_user
    @person = Player.new(user[:name], user[:breaker]
    )
    @pc = Player.new('Computer', 1 - user[:breaker])
  end

  def read_user
    puts "What's your name?"
    name = gets.chomp

    while true
      puts 'Do you wanna be the Guesser (0) or the Breaker(1)?'
      breaker = gets.chomp.to_i
      break if [0, 1].include? breaker

      continue
    end
    { name: name, breaker: breaker }
  end

  def print_feedback
    p @guess
    puts ''
    puts "#{clues[:number_right]} Right Numbers in the Wrong Position "
    puts "#{clues[:position_right]} Right Numbers in the Right Position "
    puts ''
  end

  def read_code_human
    loop do
      puts "Turn #{@turn}: Type in four numbers (1..6) to be your code. The computer won't know."
      @code = gets.chomp.strip.downcase

      break if validate_code(@code)

      continue

    end
  end

  def read_guess_human
    loop do
      puts "Turn #{@turn}: Type in four numbers (1..6) to guess the code. Or `q` if you want to leave"
      @guess = gets.chomp.strip.downcase

      if @guess  == 'q'
        @game_on = false
        return false
      end

      break if validate_code(@guess)

      continue

    end
  end

  def read_guess_pc
    @guess = Array.new(4) { rand(1..6) }.join
  end

  def validate_code(code)
    begin
      Integer(code)
    rescue ArgumentError
      return false
    end

    false unless code.length != 4
    true
  end

  def clues
    @position_right = 0
    @number_right = 0
    @guess.split('').each_with_index do |number, index|
      if number == @code[index]
        @position_right += 1
      elsif @code.include? number
        @number_right += 1
      end
    end
    { number_right: @number_right, position_right: @position_right }
  end

  def check_result
    if clues[:position_right] == 4
      @game_on = false
      puts 'Parabens! Voce acertou.'
    end

    if @turn > 10
      @game_on = false
      puts 'Mais sorte na proxima vez.'
    end
  end

end

class Player
  attr_accessor :breaker, :name, :computer
  def initialize(name, breaker = 1, computer = false)
    @breaker = breaker
    @name = name
    @computer = computer
  end
end

master_mind = MasterMind.new
master_mind.game


