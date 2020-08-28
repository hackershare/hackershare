# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  self.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new(
    min_threads: 4,
    max_threads: 10 * Concurrent.processor_count
  )
end
