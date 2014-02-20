require 'spec_helper'

describe 'counting wins per player' do
  include_context 'kicker'

  context 'team with' do

    it 'single player' do
      register(:black, :offense, 'Sebastian')
      win_for(:black)
      expect(events.player_ranking).to eq([
        new_ranking({
          'Sebastian' => 1
        })
      ])
    end

    it 'two player' do
      register(:white, :offense, 'Tom')
      register(:white, :defense, 'Jerry')
      win_for(:white)
      expect(events.player_ranking).to eq([
        new_ranking({
          'Tom' => 1,
          'Jerry' => 1
        })
      ])
    end

  end

  it 'ranking increases only for winning team' do
      register(:black, :offense, 'Jerry')
      register(:white, :offense, 'Tom')
      win_for(:black)
      expect(events.player_ranking).to eq([
        new_ranking({
          'Jerry' => 1,
          'Tom' => 0
        })
      ])
  end

  it 'stores ranking over multiple games' do
      register(:black, :offense, 'Jerry')
      register(:white, :offense, 'Tom')
      2.times{ win_for(:black) }
      expect(events.player_ranking.last).to eq(
        new_ranking({
          'Jerry' => 2,
          'Tom' => 0
        })
      )
  end


end

