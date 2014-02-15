require 'spec_helper'

describe 'game score' do
  include_context 'kicker'

  new_game_result = Kicker::Score.new(0, 0).to_s
  white_has_one_goal = Kicker::Score.new(0, 1).to_s
  white_has_two_goals = Kicker::Score.new(0, 2).to_s
  black_has_one_goal = Kicker::Score.new(1, 0).to_s

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

  context 'player ranking' do

    it 'number of won games increases' do

#      expect(output).to receive(:on_new_player_ranking).with(white_has_two_goals)

    end

  end


end
