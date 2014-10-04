require 'socket'
require 'json'

class Field
            #01234567890123456789=12345678901234567890\n#
  ENDLINE = "------------                 ------------"
  KEEPER  = '======='
  BALL  = 'o'

  attr_accessor :ball, :opponent_keeper, :my_keeper

  def initialize
    @ball = {x: 20, y: 15}
    @opponent_keeper = { pos: 17 }
    @my_keeper = { pos: 17 }
    32.times {printf "\n" }
  end

  def set_pos(json)
    @ball = json[:ball]
    @opponent_keeper = json[:opponent_keeper]
    @my_keeper = json[:my_keeper]
  end

  def flush
    printf "\e[34A"
    printf "\n"
    printf "\n"
    printf ENDLINE + "\n"
    printf keeper_line(@opponent_keeper) + "\n"
    (2..28).each do |y|
      if y == @ball[:y]
        printf ball_line + "\n"
      else
        printf "|                                       |" + "\n"
      end
    end
    printf keeper_line(@my_keeper) + "\n"
    printf ENDLINE + "\n"
    printf "\n"
  end

  private

  def ball_line
    line = "|"
    (ball[:x] - 1).times do
      line << " "
    end
    line << BALL
    (ENDLINE.size - BALL.size - ball[:x] - 1).times do
      line << " "
    end
    line << "|"
  end

  def keeper_line(keeper)
    line = "|"
    (keeper[:pos] - 1).times do
      line << " "
    end
    line << KEEPER
    (ENDLINE.size - KEEPER.size - keeper[:pos] - 1).times do
      line << " "
    end
    line << "|"
  end
end

