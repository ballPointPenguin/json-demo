# frozen_string_literal: true

module RequestSpecHelper
  # include Warden::Test::Helpers

  # TODO pull from https://github.com/heartcombo/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)

  def jsonapi_data
    JSON.parse(response.body).deep_symbolize_keys[:data]
  end
end
