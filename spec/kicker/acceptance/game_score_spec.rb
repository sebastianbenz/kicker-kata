require 'spec_helper'

describe 'game score' do
  include_context 'kicker'

  let(:new_game_result){ score(0,0) }
  let(:white_has_one_goal){ score(0,1) } 
  let(:white_has_two_goals){ score(0,2) }
  let(:black_has_one_goal){ score(1,0) }

  def score(black, white)
    Kicker::Score.black_and_white(black, white).to_s
  end

  context 'in game results' do

    context 'black scores' do

      it 'new score is black 1 / white 0' do
        goal_for(:black)
        expect(events.scores).to eq([
          black_has_one_goal
        ])
      end

    end

    context 'white scores' do

      it 'once -> 0-1' do
        goal_for(:white)
        expect(events.scores).to eq([
          white_has_one_goal
        ])
      end

      it 'twice -> 0-2' do
        2.times { goal_for(:white) }
        expect(events.scores).to eq([
          white_has_one_goal,
          white_has_two_goals
        ])
      end

      it '7 times -> new game 0-1' do
        7.times { goal_for(:white) }
        expect(events.scores.last).to eq(
          white_has_one_goal
        )
      end

    end

  end

  context 'new player registers' do

    it 'starts new game' do
        register(:white, :offense, 'Any Player')
        expect(events.scores).to eq([
          new_game_result
        ])
    end

  end


end
