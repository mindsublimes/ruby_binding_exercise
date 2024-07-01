class Agent
  def initialize(name)
    @name = name
  end

  def get_bid_increase
    rand(0..100)
  end
end

class Bidding
  def initialize(agents)
    @agents = agents
    @bids = Hash.new(0)
    @active_agents = agents.dup
  end

  def run
    highest_bid = 0

    @agents.each do |agent|
      bid_increase = agent.get_bid_increase
      if bid_increase > 0
        @bids[agent] = bid_increase
        highest_bid = @bids[agent] if @bids[agent] > highest_bid
      else
        @active_agents.delete(agent)
      end
    end

    loop do
      any_bid_increase = false

      @active_agents.each do |agent|
        if @bids[agent] < highest_bid
          bid_increase = agent.get_bid_increase
          if bid_increase > 0
            @bids[agent] += bid_increase
            highest_bid = @bids[agent] if @bids[agent] > highest_bid
            any_bid_increase = true
          else
            @active_agents.delete(agent)
          end
        end
      end

      if @active_agents.all? { |agent| @bids[agent] == highest_bid }
        break
      end

      break unless any_bid_increase
    end

    @bids
  end
end

# examples
agents = [Agent.new("Agent 1"), Agent.new("Agent 2"), Agent.new("Agent 3")]
bidding = Bidding.new(agents)
result = bidding.run
puts result.inspect
