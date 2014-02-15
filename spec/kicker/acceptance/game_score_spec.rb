require 'spec_helper'

describe 'game score' do

  let(:output){ double('output') }
  let(:statistics){ Kicker::Statistics.new(output) }
  new_game_result = Kicker::Score.new(0, 0)
  white_has_one_goal = Kicker::Score.new(0, 1)
  white_has_two_goals = Kicker::Score.new(0, 2)
  black_has_one_goal = Kicker::Score.new(1, 0)
  let(:goal_white){ 'goal:white' }
  let(:goal_black){ 'goal:black' }
  let(:new_player){ 'register:white:offense:A' }

  context 'in game results' do

    context '' do

      it 'new score is black 1 / white 0' do
        expect(output).to receive(:on_new_score).with(black_has_one_goal)
        statistics.handle_event(goal_black)
      end

    end

    context 'white scores' do

      it 'once -> 0-1' do
        expect(output).to receive(:on_new_score).with(white_has_one_goal)
        statistics.handle_event(goal_white)
      end

      it 'twice -> 0-2' do
        expect(output).to receive(:on_new_score).once.ordered.with(white_has_one_goal)
        expect(output).to receive(:on_new_score).once.ordered.with(white_has_two_goals)
        2.times { statistics.handle_event(goal_white) }
      end

      it '7 times -> new game 0-1' do
        expect(output).to receive(:on_new_score).exactly(6).times.ordered
        expect(output).to receive(:on_new_score).once.ordered.with(white_has_one_goal)
        7.times{ statistics.handle_event(goal_white) } 
      end

    end

  end

  context 'new player registers' do

    it 'starts new game' do
        expect(output).to receive(:on_new_score).with(new_game_result)
        statistics.handle_event(new_player)
    end

  end

  context 'player ranking' do

    it 'number of won games increases' do

#      expect(output).to receive(:on_new_player_ranking).with(white_has_two_goals)

    end

  end


end
