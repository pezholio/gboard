describe Gboard::Metrics do

  it 'gets achievement points', :vcr do
    metrics = described_class.new

    expect(metrics.acheivement).to eq(93)
  end

  it 'gets behaviour points', :vcr do
    metrics = described_class.new

    expect(metrics.behaviour).to eq(30)
  end

  it 'gets total points', :vcr do
    metrics = described_class.new

    expect(metrics.total).to eq(63)
  end

  it 'gets events', :vcr do
    metrics = described_class.new

    expect(metrics.events.count).to eq(3)
    expect(metrics.events[0]).to eq({
      :type=>"Achievement",
      :category=>"Merit Points1",
      :points=>"1",
      :date=>DateTime.parse('2016-02-04T00:00:00+00:00'),
      :comments=>"Not Recorded"
    })
    expect(metrics.events[1]).to eq({
      :type=>"Achievement",
      :category=>"Merit Points5",
      :points=>"5",
      :date=>DateTime.parse('2016-02-04T00:00:00+00:00'),
      :comments=>"Not Recorded"
    })
    expect(metrics.events[2]).to eq({
      :type=>"Behaviour",
      :category=>"Disruptive Behaviour",
      :points=>"1",
      :date=>DateTime.parse('2016-02-04T00:00:00+00:00'),
      :comments=>"Gwilym was put on red for having two ambers for pulling faces at children and silly behaviour at lunchtime."
    })
  end

end
