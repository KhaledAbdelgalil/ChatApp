require 'rails_helper'

RSpec.describe "Apps", type: :request do
  describe "Good Scenarios" do
    describe "post /apis/v1/applications/create" do
      it "creates an application" do
        application_name = "test_application_name"
        post "/apis/v1/applications/create", params: {name: application_name}

        expect(response).to have_http_status(200)
        json_response_body = JSON.parse(response.body)
	expect(json_response_body["status"]).to eq("SUCCESS")
	expect(json_response_body["message"]).to eq("App is created")
        expect(json_response_body["data"]).to_not be_nil
        expect(json_response_body["data"]["created_at"]).to_not be_nil
        expect(json_response_body["data"]["name"]).to eq(application_name)
        expect(json_response_body["data"]["token"].length).to be > 10
      end
    end


    describe "get /apis/v1/applications/:application_token" do
      it "gets a client application by identifier token" do
        application_name = "test_client_application"
	post "/apis/v1/applications/create", params: {name: application_name}
	json_response_body = JSON.parse(response.body)
	token = json_response_body["data"]["token"]

        get "/apis/v1/applications/#{token}"

        expect(response).to have_http_status(200)
        json_response_body = JSON.parse(response.body)
	expect(json_response_body["status"]).to eq("SUCCESS")
	expect(json_response_body["message"]).to eq("Loaded app")
        expect(json_response_body["data"]).to_not be_nil
        expect(json_response_body["data"]["created_at"]).to_not be_nil
        expect(json_response_body["data"]["name"]).to eq(application_name)
        expect(json_response_body["data"]["token"]).to eq(token)
      end
    end
  end

  describe "Bad Scenarios" do
    describe "post apis/v1/applications/create" do
      it "not given a name" do
        post "/apis/v1/applications/create", params: {application: {name: {}}}
        expect(response).to have_http_status(422)
	json_response_body = JSON.parse(response.body)
        expect(json_response_body["status"]).to eq('ERROR')
	expect(json_response_body["data"]["name"][0]).to eq('can\'t be blank')
      end
    end
  end
 
end
