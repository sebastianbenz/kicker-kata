module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor
      @teams = Teams.new

      @ranking = {}

      @score_counter = Score.black_and_white
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
      @score_monitor.on_new_score(@score_counter)
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
        block.call(p.name) 
      end
    end

  end


  class Score 

    def self.black_and_white(black=0, white=0)
      Score.new({'black' => black, 'white' => white })
    end

    def initialize(scores)
      @scores = scores
      @observers = []
    end

    def goal(new_score)
      count_score(new_score)
      notify_observers
    end

    def start_new_game
      @scores.each { |t, s| @scores[t] = 0 }
    end

    def to_s
      "score:#{@scores.to_json}"
    end

    def on_game_ended(&observer)
      @observers << observer
    end

    private

    def count_score(new_score)
      @scores[new_score.team] += 1
    end

    def notify_observers
      @scores.select {|t,s| s == GOALS_TO_WIN}.each do |team, score|
        @observers.each {|o| o.call(team)}
      end
    end

  end

  class ScoreCounter

    def initialize
      start_new_game
      @observers = []
    end

    def goal(new_score)
      count_score(new_score)
      notify_observers
    end

    def start_new_game
      @score = {
        "black" => 0,
        "white" => 0
      }
    end

    def current_score
      Score.new(@score)
    end

    def on_game_ended(&observer)
      @observers << observer
    end

    private

    def count_score(new_score)
      @score[new_score.team] += 1
    end

    def notify_observers
      @score.select {|t,s| s == GOALS_TO_WIN}.each do |team, score|
        @observers.each {|o| o.call(team)}
      end
    end


  end

end
