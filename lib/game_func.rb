# frozen_string_literal: true

require_relative 'pieces/king'

# A module for game class functions that will be used by other classes
module GameFunc
  def check?(player, board)
    board_array = board.instance_variable_get(:@board_array)

    opponent_moves(player, board).each do |move|
      next unless move.removed

      y, x = move.removed
      return true if board_array[y][x].is_a? King
    end

    false
  end

  def opponent_moves(player, board)
    result = []

    opponent_pieces(player.color, board).each do |piece, pos|
      move = piece.possible_moves(board, pos)
      result.concat(move)
    end

    result
  end

  def opponent_pieces(color, board)
    opponent_color = color == 'white' ? 'black' : 'white'
    board.player_pieces(opponent_color)
  end
end
