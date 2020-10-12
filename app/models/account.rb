class Account < ApplicationRecord
  def withdraw(amount)
    update(balance: balance - amount)
  end

  def deposit(amount)
    update(balance: balance + amount)
  end

  def transfer(recipient, amount)
    # Using transactions we are able to prevent unwanted withdrawals if later in
    # the process there was an error (like in the raise)
    # Important: the instance will reflect the substraction but the DB will not change
    # So after the transaction happens I think is a good idea to reload the instance
    # So that We get the real attribute values from DB
    transaction do
      withdraw(amount)
      # What if we are getting the withdrawal from a third party service like stripe
      # We could have a case where this could fail.
      raise StandardError, 'Oops'

      recipient.deposit(amount)
    end
  end
end
