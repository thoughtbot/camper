
# frozen_string_literal: true

RSpec.describe Camper::Client::SubscriptionsAPI do
  before(:all) do
    @client = Camper.client
  end

  context 'errors' do
    context '#subscription' do
      it 'raises an error if the resource does not have subscriptions' do
        resource = Camper::Resource.create({ url: 'https://3.basecampapi.com' })

        expect { @client.subscription(resource) }.to raise_error(Camper::Error::ResourceHasNoSubscriptions)
      end
    end
  end
end
