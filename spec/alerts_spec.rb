describe Gboard::Alerts do

  it 'grabs events from the current day', :vcr do
    Timecop.travel("2016-02-04T15:30:00Z")
    expect_any_instance_of(Gboard::Metrics).to receive(:events) {
      [
        {
          type: "Some type",
          category: "Merit Points1",
          points: "1",
          date: DateTime.parse("2016-02-04T00:00:00Z"),
          comments: "Guh"
        },
        {
          type: "Some type",
          category: "Merit Points1",
          points: "1",
          date: DateTime.parse("2016-02-03T00:00:00Z"),
          comments: "Guh"
        },
      ]
    }
    expect(Gboard::Alerts).to receive(:send_email).with([{
      type: "Some type",
      category: "Merit Points1",
      points: "1",
      date: DateTime.parse("2016-02-04T00:00:00Z"),
      comments: "Guh"
    }])
    Gboard::Alerts.perform
    Timecop.return
  end

  it 'gets emails' do
    expect(Gboard::Alerts.emails).to eq([
      {
        "email" => "foo@example.com"
      },
      {
        "email" => "bar@example.com"
      }
    ])
  end

  it 'gets the correct subject lines' do
    merit = {
      type: "Achievement"
    }

    behaviour = {
      type: "Behaviour"
    }

    expect(Gboard::Alerts.subject merit).to eq("Gwilym's got merit points!")
    expect(Gboard::Alerts.subject behaviour).to eq("Uh oh, Gwilym's in trouble...")
  end

  it 'gets the correct email template for behaviour' do
    expect(Gboard::Alerts).to receive(:behaviour_text)

    event = {
      type: "Behaviour"
    }

    Gboard::Alerts.text(event)
  end

  it 'gets the correct email template for merit' do
    expect(Gboard::Alerts).to receive(:merit_text)

    event = {
      type: "Achievement"
    }

    Gboard::Alerts.text(event)
  end

  it 'returns the correct text for an achievement email' do
    event = {
      type: "Some type",
      category: "Merit Points1",
      points: "1",
      date: DateTime.parse("2016-02-03T00:00:00Z"),
      comments: "Guh"
    }

    text = Gboard::Alerts.merit_text event
    expect(text).to match(/1 merit points/)
  end

  it 'returns the correct text for a behaviour email' do
    event = {
      type: "Behaviour",
      category: "Disruptive Behaviour",
      points: "1",
      date: DateTime.parse('2016-02-04T00:00:00+00:00'),
      comments: "Gwilym was put on red for having two ambers for pulling faces at children and silly behaviour at lunchtime."
    }

    text = Gboard::Alerts.behaviour_text event
    expect(text).to match(/1 behaviour points/)
    expect(text).to match(/for Disruptive Behaviour/)
    expect(text).to match(/Gwilym was put on red for having two ambers for pulling faces at children and silly behaviour at lunchtime/)
  end

end
