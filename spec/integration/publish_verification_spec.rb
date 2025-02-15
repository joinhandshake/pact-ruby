require 'pact/provider/verification_results/publish_all'
require 'pact/provider/pact_uri'

describe "publishing verifications" do
  before do
    allow(Pact.configuration).to receive(:provider).and_return(provider_configuration)
    allow($stdout).to receive(:puts)
  end

  let(:provider_configuration) do
    double('provider_configuration',
      application_version: '1.2.3',
      publish_verification_results?: true,
      branch: nil,
      tags: [])
  end

  let(:pact_sources) do
    [instance_double('Pact::Provider::PactSource', consumer_contract: consumer_contract, pact_hash: pact_hash, uri: pact_uri)]
  end

  let(:pact_uri) do
    instance_double('Pact::Provider::PactURI', uri: 'pact.json', options: {}, metadata: metadata)
  end

  let(:consumer_contract) { instance_double('Pact::ConsumerContract', interactions: [pact_interaction])}
  let(:pact_interaction) { instance_double('Pact::Interaction', _id: "1") }

  let(:metadata) { { notices: notices} }
  let(:notices) { instance_double('Pact::PactBroker::Notices', after_verification_notices_text: ['hello'] ) }

  let(:pact_hash) do
    {
      'interactions' => [{}],
      '_links' => {
        'pb:publish-verification-results' => {
          'href' => 'http://publish/'
        }
      }
    }
  end

  let(:created_verification_body) do
    {
      '_links' => {
        'self' => {
          'href' => 'http://created'
        }
      }
    }.to_json
  end

  let(:test_results_hash) do
    {
      tests: [
        {
          testDescription: '1',
          status: 'passed',
          pact_uri: pact_uri,
          pact_interaction: pact_interaction
        }
      ]
    }
  end

  subject { Pact::Provider::VerificationResults::PublishAll.call(pact_sources, test_results_hash) }

  let!(:request) do
    stub_request(:post, 'http://publish').to_return(status: 200, headers: {'Content-Type' => 'application/hal+json'}, body: created_verification_body)
  end

  it "publishes the results" do
    subject
    expect(request).to have_been_made
  end
end
