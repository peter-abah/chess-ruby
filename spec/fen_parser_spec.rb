# frozen_string_literal: true

require_relative '../lib/fen_parser'
require_relative '../lib/position'
require_rel '../lib/pieces'

describe FENParser do
  let(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0' }

  describe '#parse' do
    context 'when called for a valid fen' do
      let(:valid_notation) { '8/8/8/r7/8/8/8/8 w KQkq e4 2 1' }
      let(:fen_parser) { described_class.new(valid_notation) }
      let(:result) { fen_parser.parse }

      it 'returns a result containing the correct pieces' do
        result = fen_parser.parse[:pieces]
        expect(result).to contain_exactly(
          be_a(Rook).and(have_attributes(color: 'black', position: Position.parse('a5')))
        )
      end

      it 'the correct active color is returned' do
        expect(result[:active_color]).to eq :white
      end
      
      it 'returns the correct castling rights' do
        expect(result[:castling_rights]).to(
          have_attributes(kingside: { white: true, black: true }, queenside: { white: true, black: true })
        )
      end
      
      it 'returns the correct en passant square' do
        expect(result[:en_passant_square]).to eq Position.parse('e4')
      end
      
      it 'returns the correct halfmove clock' do
        expect(result[:halfmove_clock]).to eq 2
      end
      
      it 'returns the correct fullmove number' do
        expect(result[:fullmove_no]).to eq 1
      end
    end

    context 'when called for an invalid fen' do
      let(:invalid_notation) { '3/8/1/3/asdfghjk/10d/8/pppppppp/8' }
      subject(:fen_parser) { described_class.new(:invalid_fen) }

      it 'should raise an Error' do
        expect { fen_parser.parse }.to raise_error StandardError
      end
    end
  end
  
  describe '::pieces_to_fen' do
    context 'when called with an array containing one black rook at a8' do
      let(:pieces) { [Pawn.new('white', Position.parse('a8'))] }
      
      it 'should return the valid fen notation' do
        expected_fen_notation = 'P7/8/8/8/8/8/8/8'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
    
    context 'when there are more than one pieces' do
      let(:pieces) { [
        Pawn.new('black', Position.parse('e4')),
        Knight.new('white', Position.parse('d1'))
      ] }

      it 'should return the valid fen notation' do
        expected_fen_notation = '8/8/8/8/4p3/8/8/3N4'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
    
    context 'when there are more than one piece on a rank' do
      let(:pieces) do
        (0..7).map { |x| Pawn.new('black', Position.new(y: 1, x: x)) }
      end
 
      it 'should return the valid fen notation' do
        expected_fen_notation = '8/pppppppp/8/8/8/8/8/8'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
  end
end
