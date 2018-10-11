module HomeHelper

  def spare_change(amount)
    amount = amount.scan(/[.0-9]/).join().to_i
    nearest_100 = amount.round(-2)
    rounded_value = nearest_100 < amount ? (amount + 100).round(-2) : nearest_100
    (rounded_value - amount).abs
  end
end
