class Expense < ActiveRecord::Base
	validates :start_date, :description, :amount, presence: true

	# before_save :format_date

	# def format_date
	# 	self.start_date	
	# end

end
