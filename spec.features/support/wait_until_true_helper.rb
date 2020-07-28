module WaitUntilTrueHelper
  def self.included(klass)
    klass.include VerboseHelper
  end

  def wait_until_true(timeout: Capybara.default_max_wait_time + 5)
    time = Time.current
    max_time = time + timeout
    res = nil

    loop do
      begin
        res = yield
      rescue StandardError => e
        verbose "Exception #{e.inspect} in wait_until_true\n#{e.backtrace[0..10].join("\n")}"
      end
      break if res || Time.current > max_time

      sleep(0.02)
    end

    raise "Timeout waiting for block to return true" unless res

    res
  end
  alias wait_for wait_until_true
end
