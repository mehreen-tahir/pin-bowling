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
    return [false, 'Input is invalid'] if (open_frame.first_roll.to_i + input > Frame::MAX_PINS) || input < 0
    return [false, 'Game over, Max Frame limit is reached'] if frames_limit_reached?

    #TODO handle bonus round balls
    true
  end

  def frames_limit_reached?
    return false if open_frame.number < TOTAL_FRAMES
    open_frame.number >= TOTAL_FRAMES && open_frame.second_roll.present?
  end
end
