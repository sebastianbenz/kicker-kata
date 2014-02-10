module Event

    FACTORIES = {
        'goal'     => -> (fragments){ 
                    Goal.new(fragments.first.to_sym) 
      },
        'register' => -> (fragments){ 
                    team = fragments[0].to_sym
                    position = fragments[1].to_sym
                    name = fragments[2].to_sym
                    Register.new(team, position, name) 
      }
    }

  def self.from_string(string)
    first, *rest = string.split(':')
    factory = FACTORIES.fetch(first)
    factory.call(rest)

  end

  Goal = Struct.new(:team)
  Register = Struct.new(:team, :position, :name)
  
end
