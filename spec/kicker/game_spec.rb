require 'spec_helper'

describe 'Keeping score' do

  let(:goal_black){ Event.from_string('goal:black') }
  let(:game){ 
    game = Kicker::Game.new 
    game.on_result do |new_result|
      @result = new_result
    end
    game
  }

  (1..5).each do |non_winning_goal_count|

    it 'no winner before 6 goals' do
      non_winning_goal_count.times { black_scores }
      expect(@result).to eq(nil)
    end

  end

  it 'notifies winner after 6 goals' do
    6.times { black_scores }
    expect(@result.winner).to eq(:black)
    expect(@result.looser).to eq(:white)
  end

  def black_scores()
    game.handle_event(goal_black)
  end

end
