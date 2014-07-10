require 'spec_helper'

describe ExpensesController do

	it 'should response 200 status' do
		get :index
		assert_equal 200, response.status
	end

	it 'should return expenses' do
		expense = FactoryGirl.create(:expense)
		get :index
		expect(assigns(:expenses)).to be_present
		expect(response.status).to eql(200)
		expect(response.content_type).to eql(Mime::JSON.to_s)
	end

end
