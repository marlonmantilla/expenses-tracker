require 'spec_helper'

describe Api::V1::ExpensesController do
	let(:expense){ FactoryGirl.create(:expense) }
	before do
		@user = FactoryGirl.create(:user, email: "marman0315@gmail.com", password: "123456789")
	end

	def encode_credentials(email, password)	
		ActionController::HttpAuthentication::Basic.encode_credentials(email, password)	
	end	

	def set_auth_header
		request.env['HTTP_AUTHORIZATION'] = encode_credentials(@user.email, @user.password)
	end

	it 'should authenticate with valid credentials' do
		set_auth_header
		get :index, {format: :json}
		response.status.should == 200
	end

	it 'should return wrong credentials' do
		get :index, {format: :json}
		response.status.should == 401
	end

	it 'should return an expense' do
		set_auth_header
		get :show, format: :json, id: expense.id
		response.status.should == 200
	end

	it 'should save an expense' do
		set_auth_header
		post :create, { format: :json, expense: { start_date: Date.today(), description: 'Taxes', comment: 'My monthly taxes', amount: 150 } }
		expect(assigns(:expense)).to be_present
		response.content_type.should == Mime::JSON.to_s
		Expense.last.description.should == assigns(:expense).description
	end

	it 'should NOT save expense with wrong parameters' do
		set_auth_header
		post :create, { format: :json, expense: { start_date: 'not a date', 
			description: nil, comment: nil, amount: 150 } }
		response.content_type.should == Mime::JSON.to_s
		response.status.should == 422
		body = JSON.parse(response.body)
		expect(body["start_date"].include?("can't be blank")).to be_true
		expect(Expense.last).to be_nil
	end

	it 'should update an expense' do
		set_auth_header
		put :update, { id: expense.id, expense: { description: 'Setting Description', start_date: Date.today + 1.day  } }
		response.status.should == 200
		response.content_type.should == Mime::JSON.to_s
		expense.reload.description.should == 'Setting Description'
	end

	it 'should delete an expense' do
		set_auth_header
		delete :destroy, { id: expense.id }
		Expense.count.should == 0
	end

end