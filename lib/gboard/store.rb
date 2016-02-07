module Gboard
  class Store

    def self.perform
      @metrics = Metrics.new
      {
        acheivement: "acheivement-points",
        behaviour: "behaviour-points",
        total: "total-points"
      }.each do |metric, name|
        store_metric name, DateTime.now, @metrics.send(metric)
      end
    end

    def self.store_metric(name, datetime, data)
      url = "#{ENV['METRICS_API_BASE_URL']}metrics/#{name}"

      json = {
        name: name,
        time: datetime.xmlschema,
        value: data
      }.to_json

      auth = {:username => ENV['METRICS_API_USERNAME'], :password => ENV['METRICS_API_PASSWORD']}

      HTTParty.post(url, :body => json, :headers => { 'Content-Type' => 'application/json' }, :basic_auth => auth )
    end

  end
end
