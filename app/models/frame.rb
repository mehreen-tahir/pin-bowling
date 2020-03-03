class Frame < ApplicationRecord
  MAX_PINS = 10

  scope :ordered_by_number, -> { order(number: :asc) }
  belongs_to :game

  def strike?
    first_roll.to_i.eql?(MAX_PINS) && second_roll.blank?
  end

  def spare?
    pins_knocked = first_roll.to_i + second_roll.to_i
    pins_knocked.eql?(MAX_PINS) && first_roll.present? && second_roll.present?
  end

  def deserves_bonus?
    strike? || spare?
  end
end
