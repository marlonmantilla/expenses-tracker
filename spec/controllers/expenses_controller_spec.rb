require 'spec_helper'

describe ExpensesController do

	let(:expense){ FactoryGirl.create(:expense) }

	it 'should response 200 status' do
		get :index
		assert_equal 200, response.status
	end

	it 'should return expenses' do
		expense	
		get :index, { format: :json } 
		expect(assigns(:expenses)).to be_present
		expect(assigns(:expenses).count).to eql(1)
		expect(response.status).to eql(200)
		expect(response.content_type).to eql(Mime::JSON.to_s)
	end

	it 'should save an expense' do
		post :create, { format: :json, expense: { start_date: Date.today(), description: 'Taxes', comment: 'My monthly taxes', amount: 150 } }
		expect(assigns(:expense)).to be_present
		response.content_type.should == Mime::JSON.to_s
		Expense.last.description.should == assigns(:expense).description
	end

	it 'should NOT save expense with wrong parameters' do
		post :create, { format: :json, expense: { start_date: 'not a date', 
			description: nil, comment: nil, amount: 150 } }
		response.content_type.should == Mime::JSON.to_s
		response.status.should == 422
		body = JSON.parse(response.body)
		expect(body["start_date"].include?("can't be blank")).to be_true
		expect(Expense.last).to be_nil
	end

	it 'should update an expense' do
		put :update, { id: expense.id, expense: { description: 'Setting Description', start_date: Date.today + 1.day  } }
		response.status.should == 200
		response.content_type.should == Mime::JSON.to_s
		expense.reload.description.should == 'Setting Description'
	end

	it 'should delete an expense' do
		delete :destroy, { id: expense.id }
		Expense.count.should == 0
	end

	it 'should get an expense' do
		get :show, id: expense.id
		response.status.should == 200
		response.content_type.should == Mime::JSON.to_s
		body = JSON.parse(response.body)
		expect(body["description"]).to eql(expense.description)
	end

	it 'should return 404 when no expense found' do
		get :show, id: 999
		response.status.should == 404
	end

	it 'should return expenses filtered' do
		start_date = Time.now
		expense1 = FactoryGirl.create(:expense, description: 'Tax Payment', comment: 'Need to pay this soon', amount: 150, start_date: start_date)
		expense2 = FactoryGirl.create(:expense, description: 'Transport', comment: 'Transport payments', amount: 15, start_date: start_date + 1.day )
		expense3 = FactoryGirl.create(:expense, description: 'Food', comment: 'This is a must', amount: 450, start_date: start_date - 2.days )
		get :index, { format: :json, filters: { description: 'Tax', comment: 'payments', amount: 150, start_date: start_date.strftime("%Y-%m-%d %I:%M %p"), end_date: (start_date+4.days).strftime("%Y-%m-%d %I:%M %p") } }
		response.status.should == 200
		response.content_type.should == Mime::JSON.to_s
		expect(assigns(:expenses).count).to eql(2)
	end

end
