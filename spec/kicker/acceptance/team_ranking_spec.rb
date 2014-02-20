require 'spec_helper'

describe 'counting wins per player' do
  include_context 'kicker'

  it 'single player' do
      register(:black, :offense, 'Sebastian')
      register(:black, :defense, 'Tim')
      win_for(:black)
      expect(events.team_ranking).to eq([
        new_team_ranking({
          ['Sebastian'] => 0,
          ['Sebastian', 'Tim'] => 1
        })
      ])
  end

end

