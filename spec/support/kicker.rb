shared_context 'kicker' do
  include Event
  include Kicker
  
  class EventRecorder

    attr_reader :scores, :team_ranking, :player_ranking

    def initialize
      @scores = []
      @team_ranking = []
      @player_ranking = []
    end

    def on_new_score(score)
      @scores << score.to_s
    end

    def on_new_team_ranking(ranking)
      @team_ranking << ranking.to_s
    end

    def on_new_player_ranking(ranking)
      @player_ranking << ranking.to_s
    end


  end

  let(:events){ EventRecorder.new }
  let(:statistics){ Kicker::Statistics.new(events) }

  def register(team, position, name)
    statistics.handle_event("register:#{team}:#{position}:#{name}")
  end

  def win_for(team)
    6.times{ goal_for(team) }
  end

  def goal_for(team)
    statistics.handle_event("goal:#{team}")
  end

  def new_ranking(values)
    Kicker::Ranking.new(values).to_s
  end

end

