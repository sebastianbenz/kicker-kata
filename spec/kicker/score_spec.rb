require 'spec_helper'

describe 'score' do

  describe 'to json' do
    subject{ Kicker::Score.new({'a' => 3, 'b' => 1}) }
    its(:to_s){ should eq('score:{"a":3,"b":1}') }
  end

end

