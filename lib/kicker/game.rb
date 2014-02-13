module Kicker 
  
  class Game

    def initialize
      @score = {}
    end

    def handle_event(event)
      case event
      when Event::Goal
        handle_goal(event)
      end

    end

    def handle_goal(goal)
      new_score = @score.fetch(goal.team, 0) + 1
      @score[goal.team] = new_score
      new_winner(goal.team) if new_score == 6
    end

    def new_winner(color)
      winning_team = Team.new(color)
      result = Result.new(winning_team, nil)
      @on_result_callback.yield(result)

    end

    def on_result(&block)
      @on_result_callback = block
    end

  end

  Result = Struct.new(:winner, :looser)
  Team   = Struct.new(:color)

end
