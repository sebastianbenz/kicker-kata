module Kicker

  GOALS_TO_WIN = 6

  class Statistics

    def initialize(score_monitor)
      @score_monitor = score_monitor
      @score_counter = ScoreCounter.new
      @teams = TeamRegistry.new

      @ranking = {}
      @black_players = {}
      @white_players = {}
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

    def handle_registration(player)
      @score_counter.start_new_game
      team = player.is_black ? @black_players : @white_players
      team[player.position] = player.name
      @teams.register(player)
      @ranking[player.name] = 0 if !@ranking.include?(player.name)
    end

    def handle_game_ended
      team = @score_counter.black_won? ? @black_players : @white_players
      update_ranking(team)
      ranking = Event::Ranking.new(@ranking)
      @score_monitor.on_new_player_ranking(ranking)
      @score_counter.start_new_game
    end

    def update_ranking(team)
      team.each { |pos, name| 
        wins = @ranking.fetch(name, 0)
        @ranking[name] = wins + 1 
      }
    end

    def fire_new_score
      score = @score_counter.current_score
      @score_monitor.on_new_score(score)
    end

  end

  class TeamRegistry

    def initialize
      @teams = Hash.new{ {} }
    end

    def register(player)
      @teams[player.position] = player.name
    end

    def each_player(team, &block) 
        puts "test:#{team} -> #{@team}"
      @teams[team].each do |pos, name|
        puts "#{pos} -> #{name}"
        block.call(pos, name)
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
    end

    def goal(new_score)
      if new_score.is_black
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

    def black_won?
      has_won(@score_black)
    end

    def has_won(score)
      score == GOALS_TO_WIN
    end

    def winning_team
      black_won? ? "black" : "white"
    end

    def on_game_end
      yield(winning_team) if game_ended?
    end


  end

end
