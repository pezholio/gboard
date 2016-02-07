describe Gboard::Store do

  it 'stores a metric', :vcr do
    Gboard::Store.store_metric('mymetric', DateTime.parse('2015-02-01T00:00:00Z'), 123)

    uri = URI.parse "#{ENV['METRICS_API_BASE_URL']}metrics/mymetric"
    uri.host.prepend("#{URI.escape ENV['METRICS_API_USERNAME']}:#{URI.escape ENV['METRICS_API_PASSWORD']}@")

    expect(WebMock).to have_requested(:post, uri).
      with(body: {
        name: 'mymetric',
        time: '2015-02-01T00:00:00+00:00',
        value: 123
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'stores all the metrics', :vcr do
    expect(Gboard::Store).to receive(:store_metric).with("acheivement-points", DateTime.now, 93)
    expect(Gboard::Store).to receive(:store_metric).with("behaviour-points", DateTime.now, 30)
    expect(Gboard::Store).to receive(:store_metric).with("total-points", DateTime.now, 63)

    Gboard::Store.perform
  end

end
