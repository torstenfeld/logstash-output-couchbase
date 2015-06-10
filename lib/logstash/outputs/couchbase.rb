# encoding: utf-8
require 'logstash/outputs/base'
require 'logstash/namespace'
require 'couchbase'

# An example output that does nothing.
class LogStash::Outputs::Couchbase < LogStash::Outputs::Base
  config_name 'couchbase'

  config :host, :validate => :array, :default => ['127.0.0.1']
  config :bucket, :validate => :string, :required => true
  config :key, :validate => :string, :required => true
  config :command, :validate => ['set', 'add', 'replace'], :default => 'set'

  public
  def register
    cluster = Couchbase::Cluster.new(@host)
    @b = cluster.open_bucket(@bucket)
  end # def register

  public
  def receive(event)
    doc = Couchbase::Document.new(:id => @key, :content => event)
    res = @b.upsert(doc)
    puts res.inspect
    # return 'Event received'
    res
  end # def event
end # class LogStash::Outputs::Couchbase
