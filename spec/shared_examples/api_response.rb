RSpec.shared_examples "API response" do
  it "should response with expected result" do
    expect(response).to have_http_status(status)
    expect(response.body).to eq expected.to_json
  end
end
