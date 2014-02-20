module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor

      @teams = Teams.new
      @ranking = Ranking.new
      @score = Score.black_and_white

      @score.on_game_end do |winning_team|
        update_statistics(winning_team)
        @score_monitor.on_new_player_ranking(@ranking)
        @score.start_new_game
      end
    end

    def update_statistics(winning_team)
      @teams.each_player(winning_team) do |name| 
        @ranking.new_winner(name)
      end
    end

    def handle_event(event)
      event = Event.from_string(event)
      case event
      when Event::Goal then @score.on_goal(event)
      when Event::Player then handle_registration(event)
      end
      fire_new_score
    end

    private

    def handle_registration(player)
      @score.start_new_game
      @teams.register(player)
      @ranking.register(player.name)
    end

    def fire_new_score
      @score_monitor.on_new_score(@score)
    end

  end

  class Ranking

    def initialize(player_rankings = {})
      @player_rankings = player_rankings
    end

    def new_winner(player)
      @player_rankings[player] += 1 
    end

    def register(player)
      @player_rankings[player] = 0 if !@player_rankings.include?(player)
    end

    def to_s
      "player-ranking:#{@player_rankings.to_json}"
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

    def on_goal(new_score)
      increase_score(new_score)
      fire_new_game_result
    end

    def start_new_game
      @scores.each { |t, s| @scores[t] = 0 }
    end

    def on_game_end(&observer)
      @observers << observer
    end

    def to_s
      "score:#{@scores.to_json}"
    end

    private

    def increase_score(new_score)
      @scores[new_score.team] += 1
    end

    def fire_new_game_result
      winning_teams.each do |team, score|
        @observers.each {|o| o.call(team)}
      end
    end

    def winning_teams
      @scores.select {|t,s| s == GOALS_TO_WIN}
    end


  end


end
