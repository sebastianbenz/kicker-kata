require 'spec_helper'

describe 'player ranking' do
  include_context 'kicker'


  it 'counts wins per player' do
    register(:black, :offense, 'Sebastian')
    win_for(:black)
    expect(events.player_ranking).to eq([
      'player-ranking:{"Tom":1}'
    ])
  end


end

