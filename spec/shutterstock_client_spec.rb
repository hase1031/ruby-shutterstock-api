require 'spec_helper'

describe Client do

  context "#initialize" do
    it "should require a block" do
			expect { Client.instance.configure }.to raise_error(ArgumentError)
    end
  end

  context 'basic auth' do
    it 'should raise an exception when client_id is not provided' do
      expect do
				Client.instance.configure do |config|
          config.client_secret = "12345"
          config.api_url = "http://api.shutterstock.com"
        end
      end.to raise_error(ArgumentError)
    end

    it 'should raise an exception when client_secret is not provided' do
      expect do
				Client.instance.configure do |config|
          config.client_id = "testuser"
          config.api_url = "http://api.shutterstock.com"
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'access token' do

    api_url  = 'https://api.shutterstock.com/v2'

    it 'should raise error for invalid client credentials' do
      expect do
				Client.instance.configure do |config|
          config.client_id = 'invalidclientid'
          config.client_secret = 'invalidclientsecret'
          config.api_url = api_url
        end
      end.to raise_error(RuntimeError)
    end

    context 'valid client credentials' do
      subject do
        client
      end

      it 'should retrieve access token' do
        expect(subject.config.access_token).not_to be_nil
        expect(subject.options[:base_uri]).to eql(api_url)
        expect(subject.options[:oauth]).to eql(
          client_id: subject.config.client_id,
          client_secret: subject.config.client_secret,
        )
        expect(subject.options[:headers]['Authorization']).to match(/\w+/)
      end

      it 'should get appropriate scope' do
        scopes = ['user.view', 'licenses.view']
        token = subject.config.access_token
        expect(token).not_to be_nil
        expect(token.scopes).to match_array(scopes)
      end
    end
  end

  context '#method_missing' do

    let(:username) { 'testuser' }
    let(:image_id) { 118_139_110 }

    it '.images.find' do
      image = client.images.find(id: image_id)
      expect(image).to be_instance_of(Image)
    end
  end
end
