# frozen_string_literal: true

module RequestSpecHelper
  def sign_in(user)
    post "/auth/sign_in", params: { email: user.email, password: user.password }

    @headers = {
      "access-token" => response.headers["access-token"],
      "client" => response.headers["client"],
      "uid" => response.headers["uid"]
    }
  end

  def sign_in_user
    user = create(:user)
    user.confirm
    sign_in(user)
  end

  def sign_out(headers)
    delete "/auth/sign_out", headers: headers
  end

  def jsonapi_data
    JSON.parse(response.body).deep_symbolize_keys[:data]
  end

  def jsonapi_errors
    JSON.parse(response.body).deep_symbolize_keys[:errors]
  end
end
