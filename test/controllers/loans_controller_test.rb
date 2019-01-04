require 'test_helper'

class LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan = loans(:one)
  end

  test "should get index" do
    get loans_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_url
    assert_response :success
  end

  test "should create loan" do
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { amount: @loan.amount, debt: @loan.debt, fee_value: @loan.fee_value, fees: @loan.fees, fees_fulfilled: @loan.fees_fulfilled, frequency: @loan.frequency, interest: @loan.interest, last_paid: @loan.last_paid, next_paid: @loan.next_paid, paid: @loan.paid, person_id: @loan.person_id, remaining_fees: @loan.remaining_fees } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should show loan" do
    get loan_url(@loan)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_url(@loan)
    assert_response :success
  end

  test "should update loan" do
    patch loan_url(@loan), params: { loan: { amount: @loan.amount, debt: @loan.debt, fee_value: @loan.fee_value, fees: @loan.fees, fees_fulfilled: @loan.fees_fulfilled, frequency: @loan.frequency, interest: @loan.interest, last_paid: @loan.last_paid, next_paid: @loan.next_paid, paid: @loan.paid, person_id: @loan.person_id, remaining_fees: @loan.remaining_fees } }
    assert_redirected_to loan_url(@loan)
  end

  test "should destroy loan" do
    assert_difference('Loan.count', -1) do
      delete loan_url(@loan)
    end

    assert_redirected_to loans_url
  end
end
