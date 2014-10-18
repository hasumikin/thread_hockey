require 'pry'

class GameCounter
  attr_reader :pair

  def initialize
    @pair = 0
    @mutex = Mutex.new
  end

  def inc
    @mutex.synchronize do
      @pair = self.pair + 1
      puts "######## @game_counter #{@pair}"
    end
  end

  def dec
    @mutex.synchronize do
      @pair = self.pair - 1
      puts "######## @game_counter #{@pair}"
    end
  end
end