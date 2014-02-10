require 'spec_helper'

describe 'Statistics' do

  let(:game_watcher){ double('game watcher') }
  let(:ranking_calculator){ double('ranking calculator') }
  let(:an_event_string){ 'register:black:offense:Sebastian' }
  let(:an_event){ 'an event' }
  let(:an_result){ double('a game result') }
  let(:a_ranking_listener){ double('ranking listener') }
  let(:a_ranking){ double('ranking') }

  let(:statistics){ 
    Kicker::Statistics.new(game_watcher, ranking_calculator) 
  }

  it 'dispatches events to game status monitor' do
    expect(game_watcher).to receive(:handle_event).with(an_event)
    Event.stub(:from_string).with(an_event_string).and_return(an_event)
    statistics.handle_event(an_event_string)
  end

  it 'updates rankings on new result' do
    expect(game_watcher).to receive(:on_result).and_yield(an_result)
    expect(ranking_calculator).to receive(:update).with(an_result)
    statistics.start
  end

  it 'notifies listeners about updated ranking' do
    expect(game_watcher).to receive(:on_result).and_yield(an_result)
    allow(ranking_calculator).to receive(:update)
    expect(ranking_calculator).to receive(:ranking).and_return(a_ranking)
    expect(a_ranking_listener).to receive(:handle_ranking).with(a_ranking)
    statistics.add_ranking_listener(a_ranking_listener)
    statistics.start

  end


end

