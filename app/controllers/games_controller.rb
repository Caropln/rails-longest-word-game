require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
    flash[:time] = Time.now.to_f
  end

  def score
    @end_time = Time.now.to_f
    @reply = params[:word]
    @result = { time: @end_time - flash[:time].to_i, score: 0 }
  # TODO: runs the game and return detailed hash of result
    unless english_word?
      @result[:message] = "not an english word"
    else
      if is_included?
        @result[:score] = (@reply.length * 100 / (@end_time - flash[:time].to_i))
        @result[:message] = "well done"
      else
        @result[:message] = "not in the grid"
      end
    end
  end

   def is_included?
    @reply.upcase.split("").all? { |letter| @letters.include? letter }
  end

 def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@rely}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    return user['found']
  end
end
