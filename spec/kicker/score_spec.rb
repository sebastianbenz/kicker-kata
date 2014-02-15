require 'spec_helper'

describe 'score' do

  describe 'to json' do
    subject{ Kicker::Score.new(3, 1) }
    its(:to_s){ should eq('score:{"black":3,"white":1}') }
  end

end

