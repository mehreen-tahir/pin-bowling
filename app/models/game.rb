class Game < ApplicationRecord
  TOTAL_FRAMES = 10

  scope :ordered_by_time, -> { order(created_at: :asc) }
  has_many :frames, dependent: :destroy

  def open_frame
    self.frames.ordered_by_number.last
  end

  def prev_frame
    open_frame_number = open_frame.number
    open_frame_number.eql?(1) ? nil : self.frames.where(number: open_frame_number - 1).first
  end

  def verify_input(input)
    return [false, 'Input is invalid'] if input.blank? || (open_frame.first_roll.to_i + input > Frame::MAX_PINS) || input < 0
    return [false, 'Game over, Max Frame limit is reached'] if frames_limit_reached?

    #TODO handle bonus round balls
    true
  end

  def self.current_game
    Game.ordered_by_time.last
  end

  def self.create_new_game
    game = Game.new
    game.save

    game.frames.build(number: 1).save if game.present?
  end

  def total_score
    self.frames.sum(:score)
  end

  def individual_frame_score
    score_hash = {}

    self.frames.ordered_by_number.each do |frame|
      score_hash[frame.number] = frame.slice([:score, :first_roll, :second_roll]) if frame.first_roll.present?
    end

    score_hash
  end

  private

  def frames_limit_reached?
    return false if open_frame.number < TOTAL_FRAMES
    open_frame.number >= TOTAL_FRAMES && open_frame.second_roll.present?
  end
end
