require 'spec_helper'
include Event

describe 'Event' do

  context 'from string' do

    context 'goal' do
      subject { Event.from_string('goal:black') }
      it { should be_a(Goal) } 
      its(:team) { should eq('black') } 
    end

    describe 'new player' do

      context 'black offense' do
        subject { Event.from_string('register:black:offense:A') }
        it { should be_a(Player) } 
        its(:position) { should eq('offense') } 
        its(:team) { should eq('black') } 
        its(:name) { should eq('A') } 
      end

      context 'white defense' do
        subject { Event.from_string('register:white:defense:B') }
        it { should be_a(Player) } 
        its(:position) { should eq('defense') } 
        its(:team) { should eq('white') } 
        its(:name) { should eq('B') } 
      end

    end

  end


end
