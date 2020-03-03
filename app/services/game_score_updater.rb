class GameScoreUpdater < ApplicationService

  def initialize(game, knocked_pins)
    @game = game
    @knocked_pins = knocked_pins
    @open_frame = @game.open_frame
    @prev_frame = @game.prev_frame
  end

  def call
    status, input_response = @game.verify_input(@knocked_pins)

    return [false, input_response] if status.blank?

    if @open_frame.first_roll.blank?
      @open_frame.update!(first_roll: @knocked_pins)
    elsif @open_frame.second_roll.blank?
      @open_frame.update!(second_roll: @knocked_pins)
    end

    update_score_of_previous_frame && update_score_of_open_frame

    @game.frames.build(number: @open_frame.number + 1).save! if create_new_frame_if_required

    [true, "Game Score Updated"]
    rescue => e
      raise e
      [false, "Score not updated because: #{e}"]
  end

  private
    def update_score_of_previous_frame
      return true if @prev_frame.blank? || @prev_frame.deserves_bonus? == false

      @last_frame_score = Frame.where(number: @prev_frame.number - 1).first.try(:score).to_i

      updated_score = @last_frame_score + @prev_frame.first_roll.to_i + @prev_frame.second_roll.to_i + @open_frame.first_roll.to_i
      updated_score += @open_frame.second_roll.to_i if @prev_frame.strike?

      @prev_frame.update!(score: updated_score)
    end

    def update_score_of_open_frame
      score = @prev_frame.try(:score).to_i + @open_frame.first_roll.to_i + @open_frame.second_roll.to_i

      @open_frame.update!(score: score)
    end

    def create_new_frame_if_required
      (@open_frame.number + 1 <= Game::TOTAL_FRAMES) && (@open_frame.deserves_bonus? || @open_frame.second_roll.present?)
    end
  end