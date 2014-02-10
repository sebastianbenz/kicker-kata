require 'spec_helper'

describe Kicker::Game do

  let(:goal_black){ Event.from_string('goal:black') }
  let(:game){ 
    game = Kicker::Game.new 
    game.on_result do |new_result|
      @result = new_result
    end
    game
  }

  it 'counts scores' do
    5.times { game.handle_event(goal_black) }
    expect(@result).to eq(nil)
    game.handle_event(goal_black)
    expect(@result.winner.color).to eq(:black)
  end




end
