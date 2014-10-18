require 'pry'
require_relative '../../common_config/base_field'

class GameCounter
  attr_reader :pair

  def initialize
    @pair = 0
    @mutex = Mutex.new
    @cv = ConditionVariable.new
  end

  def inc
    @mutex.synchronize do
      while BaseField::MAX_GAME_COUNT <= @pair do
        @cv.wait(@mutex)
      end
      @pair += 1
      puts "######## @game_counter #{@pair}"
    end
  end

  def dec
    @mutex.synchronize do
      @pair -= 1
      @cv.signal
      puts "######## @game_counter #{@pair}"
    end
  end
end