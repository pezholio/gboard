module Gboard
  class Alerts

    def self.perform
      @metrics = Metrics.new
      @events = @metrics.events.select { |e| e[:date].to_date == Date.today }
      send_email(@events) if @events.count > 0
    end

    def self.send_email(events)
      mandrill = Mandrill::API.new ENV['MANDRILL_API_KEY']
      events.each do |e|
        mandrill.messages.send email(e)
      end
    end

    def self.email(event)
      {
        "to" => emails,
        "subject" => subject(event),
        "html" => text(event),
        "from_email" => "pezholio@gmail.com"
      }
    end

    def self.emails
      ENV['RECIPIENT_EMAILS'].split(",").map { |email|
        {
          "email" => email
        }
      }
    end

    def self.text(event)
      if event[:type] == 'Achievement'
        merit_text(event)
      else
        behaviour_text(event)
      end
    end

    def self.subject(event)
      if event[:type] == 'Achievement'
        "Gwilym's got merit points!"
      else
        "Uh oh, Gwilym's in trouble..."
      end
    end

    def self.merit_text(event)
      """
        <p>Hello Mommy and Daddy</p>

        <p>Gwilym has received #{event[:points]} merit points at school!</p>

        <p>Looks like it's treat day today!</p>
      """
    end

    def self.behaviour_text(event)
      """
        <p>Hello Mommy and Daddy</p>

        <p>Uh oh! Gwilym's in trouble. He received #{event[:points]} behaviour points for #{event[:category]} today.</p>

        <p>Here's the gory details:</p>

        <p>#{event[:comments]}</p>
      """
    end

  end
end
