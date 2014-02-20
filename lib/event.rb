require 'json'

module Event

  def self.from_string(input)
    event, *rest = input.split(':')
    case event
    when 'goal' then Goal.new(rest)
    when 'register' then Player.new(rest)
    end
  end

  class Player < Struct.new(:team, :position, :name)

    def initialize(fragments)
      super(fragments[0], fragments[1], fragments[2])
    end

  end

  class Goal < Struct.new(:team)

    def initialize(team)
      super(team[0])
    end

  end

end
