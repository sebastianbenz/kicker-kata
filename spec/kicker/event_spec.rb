require 'spec_helper'

describe Event do

  describe 'goal events' do

    it 'of type Goal' do
      event = Event.from_string('goal:black')
      expect(event).to be_a(Event::Goal)
    end

    it 'for team black' do
      event = Event.from_string('goal:black')
      expect(event.team).to eq(:black)
    end

    it 'for team white' do
      event = Event.from_string('goal:white')
      expect(event.team).to eq(:white)
    end

  end

  describe 'register events' do

    before do
      @event = Event.from_string('register:black:offense:seb')
    end

    it 'of type Register' do
      expect(@event).to be_a(Event::Register)
    end

    it 'team' do
      expect(@event.team).to eq(:black)
    end


  end


end
