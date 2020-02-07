require_relative 'test_helper.rb'
require 'stringio'
require 'o_stream_catcher'
require './lib/game_setup.rb'

class GameSetupTest < Minitest::Test

  def setup
    @game_setup = GameSetup.new
    @string_io = StringIO.new
  end

  def test_it_creates_2_boards
    @string_io.puts 4
    @string_io.puts 4
    @string_io.rewind

    $stdin = @string_io
    result, stdout, stderr = OStreamCatcher.catch do
    @game_setup.start
    end

    $stdin = STDIN

    assert_equal Board, @game_setup.comp_board.class
    assert_equal Board, @game_setup.player_board.class
  end

  def test_it_can_handle_invalid_input_for_board_creation
    @string_io.puts 1
    @string_io.puts 3
    @string_io.puts 56
    @string_io.puts "lksd&*((3))"
    @string_io.puts 3
    @string_io.rewind

    $stdin = @string_io
    result, stdout, stderr = OStreamCatcher.catch do
    @game_setup.start
    end

    $stdin = STDIN
    assert_equal 3, @game_setup.player_board.new_board.height
  end

  def test_it_creates_same_number_of_ships_for_comp_and_player
    @string_io.puts 4
    @string_io.puts 4
    @string_io.puts 2
    @string_io.puts "Cruiser"
    @string_io.puts 2
    @string_io.puts "Medusa"
    @string_io.puts 3
    @string_io.rewind

    $stdin = @string_io
    result, stdout, stderr = OStreamCatcher.catch do
    @game_setup.start
    @game_setup.create_ships
    end

    $stdin = STDIN

    assert_equal Ship, @game_setup.player_ships[0].class
    assert_equal 2, @game_setup.player_ships.size
    assert_equal "Medusa", @game_setup.player_ships[1].name
    assert_equal 2, @game_setup.comp_ships.size
  end

  def test_it_can_handle_invalid_input_for_creating_ships
    @string_io.puts 4
    @string_io.puts 4
    @string_io.puts 1289
    @string_io.puts "Cruiser"
    @string_io.puts 87
    @string_io.puts "??#KLi8"
    @string_io.puts 2
    @string_io.puts "Medusa"
    @string_io.puts 3
    @string_io.rewind

    $stdin = @string_io
    result, stdout, stderr = OStreamCatcher.catch do
    @game_setup.start
    @game_setup.create_ships
    end

    $stdin = STDIN
    assert_equal "Cruiser", @game_setup.player_ships[0].name
    assert_equal 2, @game_setup.player_ships[0].length
  end

end
