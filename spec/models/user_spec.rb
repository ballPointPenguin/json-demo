# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it "can be created by factory" do
    create(:user)

    expect(User.count).to be(1)
  end

  it "must have password_confirmation" do
    expect {
      create(:user, password_confirmation: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "must have a matching password_confirmation" do
    expect {
      create(:user, password: "secretsauce", password_confirmation: "ooppwhat")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "must have a valid email" do
    expect {
      create(:user, email: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      create(:user, email: "not_email_address")
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      create(:user, email: "@bbc.co.uk")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "must have a unique email" do
    create(:user, email: "original@test.co")

    expect {
      create(:user, email: "original@test.co")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is valid with only email and password" do
    User.create(
      email: "valid@email.co",
      password: "verycryptic",
      password_confirmation: "verycryptic"
    )

    expect(User.count).to be(1)
  end

  it "is not admin by default" do
    user = User.create(
      email: "valid@email.co",
      password: "verycryptic",
      password_confirmation: "verycryptic"
    )

    expect(user.is_admin).to be(false)
  end

  it "can be an admin" do
    user = User.create(
      email: "valid@email.co",
      is_admin: true,
      password: "verycryptic",
      password_confirmation: "verycryptic"
    )

    expect(user.is_admin).to be(true)
  end
end
