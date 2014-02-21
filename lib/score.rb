module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor

      @teams = Teams.new
      @player_ranking = Ranking.player_ranking
      @team_ranking = Ranking.team_ranking
      @score = Score.black_and_white

      @score.on_game_end do |winning_team|
        update_statistics(winning_team)
        @score_monitor.on_new_player_ranking(@player_ranking)
        @score_monitor.on_new_team_ranking(@team_ranking)
        @score.start_new_game
      end
    end

    def update_statistics(winning_team)
      winning_team_players = @teams.players_in_team(winning_team).map(&:name)
      winning_team_players.each do |player| 
        @player_ranking.new_winner(player)
      end
      @team_ranking.new_winner(winning_team_players)
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
      @player_ranking.register(player.name)
      new_team = @teams.players_in_team(player.team)
      @team_ranking.register(new_team.map(&:name))
    end

    def fire_new_score
      @score_monitor.on_new_score(@score)
    end

  end

  class Ranking

    def self.player_ranking(rankings = {})
      Ranking.new('player_ranking', rankings)
    end

    def self.team_ranking(rankings = {})
      Ranking.new('team_ranking', rankings)
    end

    def initialize(name, rankings = {})
      @name = name
      @rankings = rankings
    end

    def new_winner(participant)
      @rankings[participant] += 1 if exists?(participant)
    end

    def register(participant)
      @rankings[participant] = 0 if not exists?(participant)
    end

    def exists?(participant)
      @rankings.include?(participant)
    end

    def to_s
      "#{@name}:#{@rankings.to_json}"
    end

  end


  class Teams

    def initialize
      @teams = Hash.new{ [] }
    end

    def register(player)
      @teams[player.position + player.team] = player
    end

    def players_in_team(team)
      @teams.select{ |k,v| v.team == team }.values
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
