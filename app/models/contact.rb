class Contact < ApplicationRecord
  belongs_to :user
  def initiate_transaction(transaction_type, amount)
    amount = amount.to_i
    user = self.user
    status = false
        # credit means that user sent money to contact
        if transaction_type == "credit"
           p "user balance read is :: #{user.balance}"
           status = false if user.balance < amount
           user.balance-=amount
           user.save!
           status = true
        # debit means user recieved money from contact
        elsif transaction_type == "debit" 
           user.balance+=amount
           user.save!
           status = true
        end
    return status
  end
end
