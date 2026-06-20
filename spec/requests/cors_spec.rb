# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CORS", type: :request do
  def cors_preflight_headers(origin)
    {
      "Origin" => origin,
      "Access-Control-Request-Method" => "GET"
    }
  end

  it "does not allow arbitrary origins on API preflight requests" do
    options "/api/flags", headers: cors_preflight_headers("https://evil.example")

    expect(response.headers["Access-Control-Allow-Origin"]).to be_nil
    expect(response.headers["Access-Control-Allow-Credentials"]).to be_nil
  end

  it "does not allow arbitrary origins on API GET requests" do
    get "/api/flags", headers: { "Origin" => "https://evil.example" }

    expect(response).to have_http_status(:ok)
    expect(response.headers["Access-Control-Allow-Origin"]).to be_nil
    expect(response.headers["Access-Control-Allow-Credentials"]).to be_nil
  end

  it "allows configured API origins" do
    options "/api/flags", headers: cors_preflight_headers("https://hackclub.com")

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("https://hackclub.com")
  end

  it "allows localhost for local API development" do
    options "/api/flags", headers: cors_preflight_headers("http://localhost:3000")

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("http://localhost:3000")
  end

  it "keeps credentialed current user access limited to configured origins" do
    options "/api/current_user", headers: cors_preflight_headers("https://bank.engineering")

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("https://bank.engineering")
    expect(response.headers["Access-Control-Allow-Credentials"]).to eq("true")
  end
end
