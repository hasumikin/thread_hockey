require 'socket'
require 'json'
require_relative '../../common_config/base_field'


class Field < BaseField
  attr_accessor :ball, :p2_keeper, :p1_keeper

  def initialize
    # @ball = {x: 20, y: 15}
    # @p2_keeper = { pos: 17 }
    # @p1_keeper = { pos: 17 }
    # (HEIGHT + 2).times {printf "\n" }
  end

  def set_pos(json)
    @ball = json[:ball]
    @p2_keeper = json[:p2_keeper]
    @p1_keeper = json[:p1_keeper]
  end

  def flush
    Curses.setpos(2 , 0)
    Curses.addstr "\n"
    Curses.addstr "\n"
    Curses.addstr ENDLINE + "\n"
    Curses.addstr keeper_line(@p2_keeper) + "\n"
    (2..(HEIGHT - 2)).each do |y|
      if y == @ball[:y]
        Curses.addstr ball_line + "\n"
      else
        Curses.addstr INFIELD + "\n"
      end
    end
    Curses.addstr keeper_line(@p1_keeper) + "\n"
    Curses.addstr ENDLINE + "\n"
    Curses.addstr "\n"
    Curses.refresh
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

