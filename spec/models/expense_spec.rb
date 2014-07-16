require 'spec_helper'

describe Expense do
	
	let(:wrong_params){ { start_date: nil, comment: nil, description: nil, amount: nil} }

	it{ should belong_to(:user) }

	describe 'Create' do
		it 'should NOT create an expense with empty parameters' do
			expense = FactoryGirl.build(:expense, wrong_params)
			expect(expense.valid?).to be_false
		end
	end


end
