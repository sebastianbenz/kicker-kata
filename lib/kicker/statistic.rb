module Kicker
  
  class Statistics

    def initialize(game_watcher, ranking_calculator)
      @game_watcher = game_watcher
      @ranking_calculator = ranking_calculator
      @listeners = []
    end

    def start
      @game_watcher.on_result do |result|
        @ranking_calculator.update(result)
        @listeners.each do |listener|
          listener.handle_ranking(@ranking_calculator.ranking)
        end
      end
    end

    def handle_event(event_string)
      event = Event.from_string(event_string)
      @game_watcher.handle_event(event)
    end

    def add_ranking_listener(listener)
      @listeners << listener
    end


  end

end
