module Gboard
  class Metrics

    def initialize
      @url = ENV['GBOARD_URL']
      @username = ENV['GBOARD_USERNAME']
      @password = ENV['GBOARD_PASSWORD']
      login
      load_dashboard
    end

    def agent
      @agent ||= Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }
    end

    def items
      agent.page.css('.maincontainer .items .item')
    end

    def acheivement
      items[2].css('.indicatormarks').first.text.strip.to_i
    end

    def behaviour
      items[3].css('.indicatormarks').first.text.strip.to_i
    end

    def total
      acheivement - behaviour
    end

    def events
      agent.page.css('.divMainContainer .normal').map do |e|
        type = get_type e.css('.spanStudentInfoHeader').text
        if !type.nil?
          details = e.css('.divDetails dd')
          points = get_points details[0].text
          category = get_category details[0].text

          {
            type: type,
            category: category,
            points: points,
            date: DateTime.parse(details[1].text),
            comments: (details[7] || details[4]).text
          }
        end
      end.select { |e| !e.nil? }
    end

    def get_type(text)
      if text =~ /Behaviour/
        'Behaviour'
      elsif text =~ /Achievement/
        'Achievement'
      end
    end

    def get_points(text)
      text.match(/.+\(([0-9]+)/)[1] rescue nil
    end

    def get_category(text)
      text.match(/(.+)\(/)[1].to_s.strip
    end

    private

      def login
        login_form = agent.get(@url).form
        login_form.username = @username
        login_form.password = @password
        agent.submit(login_form, login_form.buttons.first)
      end

      def load_dashboard
        agent.page.link_with(text: 'Parents/Carers').click
        agent.page.link_with(text: 'My Children Dashboard').click
      end

  end
end
