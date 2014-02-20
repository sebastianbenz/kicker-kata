require 'json'

module Event

  Player = Struct.new(:team, :position, :name)
  Goal = Struct.new(:team)

  def self.from_string(input)
    event, *fragments = input.split(':')
    case event
    when 'register' then Player.new(fragments[0], fragments[1], fragments[2])
    when 'goal' then Goal.new(fragments[0])
    end
  end


end
