module Kicker

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor
      @score_counter = GameScoreCounter.new
    end

    def handle_event(event)
      event = Event.from_string(event)
      case event
      when Event::Goal then handle_goal(event)
      when Event::Registration then handle_registration(event)
      end
      fire_new_score
    end

    def handle_goal(event)
      @score_counter.goal(event)
    end

    def handle_registration(event)
      @score_counter.reset
    end

    private

    def fire_new_score
      score = @score_counter.current_score
      @score_monitor.on_new_score(score)
    end

  end


  class Score < Struct.new(:black, :white)

    def initialize(score_black, score_white)
      super(score_black.to_i, score_white.to_i)
    end

    def to_s
      "score:{\"black\":#{black},\"white\":#{white}}"
    end

  end

  class ScoreCounter

    def initialize
      @score = 0
    end

    def inc
      if @score == 6
        @score = 1 
      else
        @score += 1 
      end
    end

    def to_i
      @score
    end

  end

  class GameScoreCounter

    def initialize
      reset
    end

    def goal(event)
      (event.is_black ? @score_black : @score_white).inc
    end

    def reset
      @score_black = ScoreCounter.new
      @score_white = ScoreCounter.new
    end

    def current_score
      Score.new(@score_black, @score_white)
    end

  end

end
