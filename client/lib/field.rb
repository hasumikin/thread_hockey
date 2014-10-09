require 'socket'
require 'json'
require_relative '../../common_config/base_field'

class Field < BaseField
  attr_accessor :ball, :p2_keeper, :p1_keeper, :event

  def initialize
  end

  def set_pos(json)
    @ball = json[:ball]
    @p2_keeper = json[:p2_keeper]
    @p1_keeper = json[:p1_keeper]
    @event = json[:event] unless json[:event] == []
  end

  # @author hasumi
  # 画面を描き直す
  def flush
    Curses.setpos(2 , 0)
    Curses.addstr "\n"
    Curses.addstr "\n"
    Curses.addstr TOPLINE + "\n"
    Curses.addstr keeper_line(@p2_keeper, @ball[:y]==1) + "\n"
    (2..(HEIGHT - 2)).each do |y|
      if y == @ball[:y]
        Curses.addstr ball_line + "\n"
      else
        Curses.addstr INFIELD + "\n"
      end
    end
    Curses.addstr keeper_line(@p1_keeper, @ball[:y]==(HEIGHT-1) ) + "\n"
    Curses.addstr ENDLINE + "\n"
    Curses.addstr "\n"
    Curses.addstr debug
    Curses.refresh
  end

  private

  # @author hasumi
  # 各要素の位置をデバッグプリントする
  def debug
    "ball_x    : #{@ball[:x]}\n" <<
    "ball_y    : #{@ball[:y]}\n" <<
    "p1_keeper : #{@p1_keeper[:pos]}\n" <<
    "p2_keeper : #{@p2_keeper[:pos]}\n" <<
    "event     : #{@event.to_s}\n"
  end

  # @author hasumi
  # キーパーライン以外のインフィールドをつくる
  def ball_line
    line = ''
    line << INFIELD
    line[@ball[:x]] = BALL
    line
  end

  # @author hasumi
  # @param [Boolean] include_ball このラインにボールが存在するか
  # 両キーパーのいるラインをつくる
  def keeper_line(keeper, include_ball=false)
    line = ''
    line << INFIELD
    line[keeper[:pos]..(keeper[:pos] + KEEPER.length - 1)] = KEEPER
    line[@ball[:x]] = BALL if include_ball && line[@ball[:x]] == ' '
    line
  end
end

