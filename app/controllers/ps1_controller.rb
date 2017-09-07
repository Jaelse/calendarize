class Ps1Controller < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def index
  end

  def dividebyzero
    @s = 1
    @b = 0
      if @b == 0
        logger.debug "about to divide by zero"
      end
  @c = @s/@b

  rescue StandardError
  raise

  end

  def nytimesscrapper
    @doc = Nokogiri::HTML(open("https://nytimes.com/"))

    @headlines = @doc.css('.story-heading')
  end
end
