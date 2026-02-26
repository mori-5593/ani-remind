ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end

  def sign_in_as(user)
    session = user.sessions.create!(
      user_agent: "TestAgent",
      ip_address: "127.0.0.1"
    )
    cookies.signed[:session_id] = { value: session.id, httponly: true }

    Current.session = session
  end

end
