module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor
      @teams = Teams.new

      @ranking = {}

      @score_counter = ScoreCounter.new
      @score_counter.on_game_ended do |winning_team|
        @teams.each_player(winning_team) do |name| 
          @ranking[name] += 1 
        end
        ranking = Event::Ranking.new(@ranking)
        @score_monitor.on_new_player_ranking(ranking)
        @score_counter.start_new_game
      end
    end

    def handle_event(event)
      event = Event.from_string(event)
      case event
      when Event::Goal then @score_counter.goal(event)
      when Event::Registration then handle_registration(event)
      end
      fire_new_score
    end

    private

    def handle_registration(player)
      @score_counter.start_new_game
      @teams.register(player)
      @ranking[player.name] = 0 if !@ranking.include?(player.name)
    end

    def fire_new_score
      score = @score_counter.current_score
      @score_monitor.on_new_score(score)
    end

  end

  class Teams

    def initialize
      @teams = Hash.new{ [] }
    end

    def register(player)
      @teams[player.position + player.team] = player
    end

    def each_player(team, &block) 
      @teams.select{ |k,v| v.team == team }.each do |k,p|
        puts "#{p} found"
        block.call(p.name) 
      end
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
      @observers = []
    end

    def goal(new_score)
      @score[new_score.team] += 1
      @score.select {|t,s| s == GOALS_TO_WIN}.each do |team, score|
        @observers.each {|o| o.call(team)}
      end
    end

    def start_new_game
      @score = {
        "black" => 0,
        "white" => 0
      }
    end

    def current_score
      Score.new(
        @score["black"],
        @score["white"])
    end

    def game_ended? 
      @score.has_value?(GOALS_TO_WIN)
    end

    def black_won?
      has_won(@score["black"])
    end

    def has_won(score)
      score == GOALS_TO_WIN
    end

    def on_game_ended(&observer)
      @observers << observer
    end

  end

end
