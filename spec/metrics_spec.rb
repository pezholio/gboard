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

end
