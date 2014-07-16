class Expense < ActiveRecord::Base
	validates :start_date, :description, :amount, presence: true

	belongs_to :user

end
