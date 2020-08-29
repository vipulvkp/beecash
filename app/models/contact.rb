class Contact < ApplicationRecord
  belongs_to :user
  def initiate_transaction(transaction_type, amount)
    user = self.user
    status = false
        # debit means that user sent money to contact
        if transaction_type == "debit"
           p "user balance read is :: #{user.balance}"
           status = false if user.balance < amount
           user.balance-=amount
           user.save!
           status = true
        # credit means user recieved money from contact
        elsif transaction_type == "credit" 
           user.balance+=amount
           user.save!
           status = true
        end
    return status
  end
end
