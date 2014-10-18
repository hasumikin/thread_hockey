require 'json'
require 'curses'
require 'pry'

class Main

  COUNTERS =
   [[' 3333333 ',
     '33     33',
     '      33 ',
     '    333  ',
     '      33 ',
     '33     33',
     ' 3333333 '],
    [' 2222222 ',
     '22     22',
     '      22 ',
     '    22   ',
     '  22     ',
     ' 22      ',
     '222222222'],
    ['   111   ',
     '  1111   ',
     '    11   ',
     '    11   ',
     '    11   ',
     '    11   ',
     ' 11111111'],
    ['         ',
     '         ',
     ' G A M E ',
     '         ',
     'S T A R T',
     '         ',
     '         ']]

  WINNER = [
    [' WW          WW ',
     '  WW   WW   WW  ',
     '  WW  W  W WW   ',
     '   WW W  W W    ',
     '    WW   WWW    '],
    ['     IIIIII     ',
     '       II       ',
     '       II       ',
     '       II       ',
     '     IIIIII     '],
    ['NN            NN',
     'NNNNN         NN',
     'NN  NNNN      NN',
     'NN    NNNN    NN',
     'NN      NNNN  NN'],
  ]

  LOSSER = [
    ['   LLL          ',
     '   LLL          ',
     '   LLL          ',
     '   LLL          ',
     '   LLL          ',
     '   LLLLLLLLLLL  '],
    ['   ooooooooooo  ',
     '   oo       oo  ',
     '   oo       oo  ',
     '   oo       oo  ',
     '   oo       oo  ',
     '   ooooooooooo  '],
    ['   SSSSSSSSSSS  ',
     '   SSS          ',
     '   SSSS         ',
     '   SSSSSSSSSS   ',
     '            SS  ',
     '   SSSSSSSSSSSS '],
    ['   EEEEEEEEEEE  ',
     '   EEE          ',
     '   EEEEEEEEEEE  ',
     '   EEE          ',
     '   EEE          ',
     '   EEEEEEEEEEE  '],
  ]

  def initialize(host='localhost')
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.timeout = 0
    @field = Field.new
    @sock = TCPSocket.open(host, 12345)
    flush
    count_down
    game
  end

  private

  def game
    loop do
      input = Curses.getstr
      request = case input[0]
      when 'n'
        "{\"key\":\"l\"}"
      when 'm'
        "{\"key\":\"r\"}"
      else
        '{}'
      end
      @sock.puts request
      flush
      sleep 0.05
    end
  end

  def flush
    @field.set_pos JSON.parse(@sock.gets).deep_symbolize_keys
    if @field.event && (@field.event.include?('you_got') || @field.event.include?('you_missed'))
      @field.flush
      @sock.puts 'game_init'
      @field.event = nil
      count_down
      @sock.puts '{}'
      flush
    end
    if @field.event && @field.event.include?('you_won')
      game_over(WINNER)
    elsif @field.event && @field.event.include?('you_lost')
      game_over(LOSSER)
    end

    @field.flush
  end

  # @author hasumi
  # ゲーム開始のカウントダウン
  def count_down
    COUNTERS.each do |counter|
      Curses.setpos((Field::HEIGHT / 2).floor - (COUNTERS[0].size / 2).floor + 4, 0)
      counter.each do |split_counter|
        line = Field::INFIELD.dup
        pos = (Field::WIDTH / 2).floor - (split_counter.size / 2).floor
        line[(pos)..(pos + split_counter.size - 1)] = split_counter
        Curses.addstr "#{line}\n"
      end
      Curses.refresh
      sleep 1
    end
  end

  def game_over(result)
    result.each do |finisher|
      Curses.setpos((Field::HEIGHT / 2).floor - (result[0].size / 2).floor + 4, 0)
      finisher.each do |split_finisher|
        line = Field::INFIELD.dup
        pos = (Field::WIDTH / 2).floor - (split_finisher.size / 2).floor
        line[(pos)..(pos + split_finisher.size - 1)] = split_finisher
        Curses.addstr "#{line}\n"
      end
      Curses.refresh
      sleep 0.5
    end
  end

end
