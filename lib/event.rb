require 'json'

module Event

  def self.from_string(input)
    event, *rest = input.split(':')
    case event
    when 'goal' then Goal.new(rest)
    when 'register' then Registration.new(rest)
    end
  end

  class Registration < Struct.new(:team, :position, :name)

    def initialize(fragments)
      super(fragments[0], fragments[1], fragments[2])
    end

    def is_black
      team === 'black' 
    end

    def is_white
      !is_black 
    end

  end

  class Goal < Struct.new(:team)

    def initialize(team)
      super(team[0])
    end

    def is_black
      team == 'black' 
    end

    def is_white
      !is_black 
    end

  end

  
  class Ranking 
    
    def initialize(ranking)
      @ranking = ranking
    end

    def to_s
      "player-ranking:#{@ranking.to_json}"
    end

  end

end
