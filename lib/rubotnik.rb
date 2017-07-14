require 'rubotnik/version'
require 'rubotnik/message_dispatch'
require 'rubotnik/postback_dispatch'
require 'rubotnik/user_store'
require 'rubotnik/user'
require 'rubotnik/cli'
require 'ui/fb_button_template'
require 'ui/fb_carousel'
require 'ui/image_attachment'
require 'ui/quick_replies'
require 'sinatra'
require 'facebook/messenger'
include Facebook::Messenger

module Rubotnik
  def self.subscribe(token)
    Facebook::Messenger::Subscriptions.subscribe(access_token: token)
  end

  # TODO: ROUTING FOR POSTBACKS
  def self.route(event, &block)
    Bot.on(event, &block) unless [:message, :postback].include?(event) # TODO: Test
    Bot.on event do |e|
      case e
      when Facebook::Messenger::Incoming::Message
        Rubotnik::MessageDispatch.new(e).route(&block)
      when Facebook::Messenger::Incoming::Postback
        Rubotnik::PostbackDispatch.new(e).route(&block)
      end
    end
  end

  # TESTING
  def self.root
    Dir.pwd
  end
end
