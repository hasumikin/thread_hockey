require 'json'
require 'pry'
require_relative '../../common_config/base_field'

class Field < BaseField
  attr_accessor :ball, :p1_keeper, :p2_keeper, :event, :score

  KEEPER_MAX_POS = WIDTH - KEEPER.size - 1

  def initialize
    @score = {p1: 0, p2: 0}
    @p1_keeper = Keeper.new(pos: 18)
    @p2_keeper = Keeper.new(pos: 18)
    restart
  end

  def restart
    @ball = {x: rand(1..(WIDTH-1)), y: rand(((HEIGHT/3).round-1)..((HEIGHT/3*2).round-1))}
    @ball_vector = first_vector
    @event = []
  end

  def update(p1, p2)
    act_ball
    act_keeper_p1(p1['key'])
    act_keeper_p2(p2['key'])
  end

  def reverse
    reversed = self.class.new
    reversed.ball[:x] = (WIDTH - 1) - self.ball[:x]
    reversed.ball[:y] = HEIGHT - self.ball[:y]
    reversed.p1_keeper.pos = (KEEPER_MAX_POS + 1) - self.p2_keeper.pos
    reversed.p2_keeper.pos = (KEEPER_MAX_POS + 1) - self.p1_keeper.pos
    events = self.event.dup.flatten
    if events.any?{|e| e == :hit_p1 }
      events.delete(:hit_p1)
      events << :hit_p2
    elsif events.any?{|e| e == :hit_p2 }
      events.delete(:hit_p2)
      events << :hit_p1
    elsif events.any?{|e| e == :you_got }
      events.delete(:you_got)
      events << :you_missed
    elsif events.any?{|e| e == :you_missed }
      events.delete(:you_missed)
      events << :you_got
    end
    reversed.score = {p1: @score[:p2], p2: @score[:p1]}
    reversed.event = events
    reversed
  end

  def to_json
    {
      ball: @ball,
      p1_keeper: {pos: @p1_keeper.pos},
      p2_keeper: {pos: @p2_keeper.pos},
      event: @event.flatten,
      score: {p1: @score[:p1], p2: @score[:p2]}
    }.to_json
  end

  def game_over?
    @score[:p1] >= GAME_OVER_SCORE || @score[:p2] >= GAME_OVER_SCORE
  end

  private

  def inner?(x, y)
    x.between?(1, WIDTH - 1) && y.between?(1, HEIGHT - 1)
  end

  def first_vector
    vectors = []
    vectors << [1, 1]   # RightUp
    vectors << [1, -1]  # RightDown
    vectors << [-1, 1]  # LeftUp
    vectors << [-1, -1] # LeftDown
    vectors[rand(4)]
  end

  def act_ball
    moved = @ball.dup
    moved[:x] += @ball_vector[0]
    moved[:y] += @ball_vector[1]
    ### ぶつかり判定
    # p1キーパー
    @event = []
    @event << if moved[:y] > (HEIGHT - 2) && (@p1_keeper.pos..(@p1_keeper.pos + KEEPER.size - 1)).include?(moved[:x])
      @ball_vector[1] = @ball_vector[1] * (-1)
      moved[:y] += @ball_vector[1] * 2
      :hit_p1
    # p2キーパー
    elsif moved[:y] < 2 && (@p2_keeper.pos..(@p2_keeper.pos + KEEPER.size - 1)).include?(moved[:x])
      @ball_vector[1] = @ball_vector[1] * (-1)
      moved[:y] += @ball_vector[1] * 2
      :hit_p2
    # 壁
    else
      wall_hit_event = []
      if moved[:x] == 0 || moved[:x] == WIDTH - 1
        @ball_vector[0] = @ball_vector[0] * (-1)
        moved[:x] += @ball_vector[0] * 2
        wall_hit_event << :hit_touchline
      end
      if moved[:y] == 0
        wall_hit_event << if TOPLINE[moved[:x]] == ' '
          @score[:p1] += 1
          game_over? ? :you_won : :you_got
        else
          @ball_vector[1] = @ball_vector[1] * (-1)
          moved[:y] += @ball_vector[1] * 2
          :hit_topline
        end
      elsif moved[:y] == HEIGHT
        wall_hit_event << if ENDLINE[moved[:x]] == ' '
          @score[:p2] += 1
          game_over? ? :you_lost : :you_missed
        else
          @ball_vector[1] = @ball_vector[1] * (-1)
          moved[:y] += @ball_vector[1] * 2
          :hit_endline
        end
      end
      wall_hit_event
    end
    @ball = moved
  end

  def act_keeper_p1(act)
    case act
    when 'r'
      @p1_keeper.pos += 1 if @p1_keeper.pos < KEEPER_MAX_POS
    when 'l'
      @p1_keeper.pos += -1 if @p1_keeper.pos > 1
    end
  end

  def act_keeper_p2(act)
    case act
    when 'r'
      @p2_keeper.pos += -1 if @p2_keeper.pos > 1
    when 'l'
      @p2_keeper.pos += 1 if @p2_keeper.pos < KEEPER_MAX_POS
    end
  end

end