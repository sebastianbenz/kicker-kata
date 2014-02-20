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
        }).to_s
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
        }).to_s
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
        }).to_s
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
        }).to_s
      )
  end

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
        }).to_s
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
        }).to_s
      )
  end

  def new_ranking(values)
    Kicker::Ranking.new(values).to_s
  end

end

