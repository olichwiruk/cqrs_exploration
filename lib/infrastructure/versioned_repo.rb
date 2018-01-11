# frozen_string_literal: true

module Infrastructure
  class VersionedRepo < SimpleDelegator
    attr_reader :event_repo

    def initialize(repo, event_repo)
      super(repo)
      @event_repo = event_repo
    end

    def save(aggregate)
      __getobj__.save(aggregate)

      event_repo.commit(aggregate.events)
    end
  end
end
