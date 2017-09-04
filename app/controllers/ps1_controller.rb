class Ps1Controller < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def index
  end

  def dividebyzero
    @s = 1
    @b = 0

  @c = @s/@b

  rescue StandardError
  raise

  end

  def nytimesscrapper
    @doc = Nokogiri::HTML(open("https://nytimes.com/"))

    @headlines = @doc.css('.story-heading')
  end
end
