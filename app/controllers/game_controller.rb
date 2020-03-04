class GameController < ApplicationController
  before_action :fetch_current_game, only: [:input, :scores]

  def create
    if Game.create_new_game
      render json: { message: "New Game Created", status: :success }.to_json
    else
      render json: { message: "New Game Couldnt be Created", status: :unprocessable_entity }.to_json
    end
  end

  def input
    return render json: { message: "Start a New Game First", status: :unprocessable_entity }.to_json if @game.blank?

    is_updated, response = GameScoreUpdater.call(@game, params[:knocked_pins].to_i)
    status = is_updated ? :success : :unprocessable_entity

    render json: { message: response, status: status}.to_json
  end

  def scores
    if @game.present?
      render json: { total_score: @game.total_score, frame_score: @game.individual_frame_score }.to_json
    else
      render json: { message: "Start a New Game First", status: :unprocessable_entity }.to_json
    end
  end

  private
    def fetch_current_game
      @game = Game.current_game
    end
end