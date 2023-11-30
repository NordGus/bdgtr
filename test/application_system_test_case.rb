require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  parallelize workers: 2

  driven_by :selenium, using: :headless_firefox, screen_size: [1920, 1080]
end
