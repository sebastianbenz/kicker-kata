require 'spec_helper'

describe 'counting wins per player' do
  include_context 'kicker'

  it 'players can register multiple times' do
      register(:black, :offense, 'Jerry')
      register(:white, :offense, 'Tom')
      win_for(:black)
      register(:black, :offense, 'Jerry')
      win_for(:black)
      expect(events.player_ranking.last).to eq(
        new_ranking({
          'Jerry' => 2,
          'Tom' => 0
        })
      )
  end

  it 'only one player per position' do
      register(:black, :offense, 'Jerry')
      register(:black, :offense, 'Tom')
      win_for(:black)
      expect(events.player_ranking.last).to eq(
        new_ranking({
          'Jerry' => 0,
          'Tom' => 1
        })
      )
  end

end

