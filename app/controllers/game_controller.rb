class GameController < ApplicationController
  before_action :fetch_current_game, only: [:input]

  def create
    if Game.create_new_game
      render json: { message: "New Game Created", status: :success }.to_json
    else
      render json: { message: "New Game Couldnt be Created", status: :unprocessable_entity }.to_json
    end
  end

  def input
    is_updated, response = GameScoreUpdater.call(@game, params[:knocked_pins].to_i)
    status = is_updated ? :success : :unprocessable_entity

    render json: { message: response, status: status}.to_json
  end

  private
    def fetch_current_game
      @game = Game.current_game
    end
end