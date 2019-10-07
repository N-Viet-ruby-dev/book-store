# frozen_string_literal: true

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 100
Delayed::Worker.default_queue_name = "default"
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, "log", "delayed_job.log"))
Delayed::Worker.queue_attributes = {
  high_priority: { priority: -10 },
  low_priority: { priority: 10 }
}
