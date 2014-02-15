module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor
      @score_counter = ScoreCounter.new
    end

    def handle_event(event)
      event = Event.from_string(event)
      case event
      when Event::Goal then handle_goal(event)
      when Event::Registration then handle_registration(event)
      end
      fire_new_score
    end

    private

    def handle_goal(event)
      @score_counter.goal(event)
      handle_game_ended if @score_counter.game_ended?
    end

    def handle_registration(event)
      @score_counter.start_new_game
    end

    def handle_game_ended
      @score_counter.start_new_game
      ranking = Event::Ranking.new({
        "Tom" => 1
      })
      @score_monitor.on_new_player_ranking(ranking)
    end

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
      start_new_game
    end

    def goal(event)
      if event.is_black
        @score_black += 1
      else
        @score_white += 1
      end
    end

    def start_new_game
      @score_black = 0
      @score_white = 0
    end

    def current_score
      Score.new(@score_black, @score_white)
    end

    def game_ended? 
      has_won(@score_black) || has_won(@score_white)
    end

    def has_won(score)
      score == GOALS_TO_WIN
    end


  end

end
