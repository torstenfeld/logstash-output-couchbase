# require "logstash/devutils/rspec/spec_helper"
require File.absolute_path(File.join(File.dirname(__FILE__), '../../lib/logstash/outputs/couchbase'))
require 'rspec'
require 'couchbase'
require 'logstash/codecs/plain'
require 'logstash/event'

describe LogStash::Outputs::Couchbase do
  let(:sample_event) { LogStash::Event.new }

  describe 'store document' do
    before {
      @key = '123'
      @expected_output = Couchbase::Document.new(:id => @key, :content => sample_event)

      # Couchbase::Cluster.any_instance.stub(:new).and_return(nil)
      # Couchbase::Cluster.any_instance.stub(:open_bucket).and_return(nil)
      # Couchbase::Cluster.any_instance.stub(:upsert).and_return(nil)
    }
    subject {
      # key = '123'
      config = {
        'host' => ['127.0.0.1'],
        'bucket' => 'default',
        'key' => @key
      }
      # expected_output = Couchbase::Document.new(:id => key, :content => sample_event)
      puts @expected_output.inspect
      # puts config['outputs']['couchbase']['key']
      output = LogStash::Outputs::Couchbase.new config
      output.register
      output.receive(sample_event)
    }

    it 'returns a string' do
      expect(subject).to be_a_kind_of(Couchbase::Document)
      # expect(subject).to eq('Event received')
    end
  end
end