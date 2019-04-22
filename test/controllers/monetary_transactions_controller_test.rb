require 'test_helper'

class MonetaryTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monetary_transaction = monetary_transactions(:one)
  end

  test "should get index" do
    get monetary_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_monetary_transaction_url
    assert_response :success
  end

  test "should create monetary_transaction" do
    assert_difference('MonetaryTransaction.count') do
      post monetary_transactions_url, params: { monetary_transaction: { description: @monetary_transaction.description, mode: @monetary_transaction.mode, value: @monetary_transaction.value } }
    end

    assert_redirected_to monetary_transaction_url(MonetaryTransaction.last)
  end

  test "should show monetary_transaction" do
    get monetary_transaction_url(@monetary_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_monetary_transaction_url(@monetary_transaction)
    assert_response :success
  end

  test "should update monetary_transaction" do
    patch monetary_transaction_url(@monetary_transaction), params: { monetary_transaction: { description: @monetary_transaction.description, mode: @monetary_transaction.mode, value: @monetary_transaction.value } }
    assert_redirected_to monetary_transaction_url(@monetary_transaction)
  end

  test "should destroy monetary_transaction" do
    assert_difference('MonetaryTransaction.count', -1) do
      delete monetary_transaction_url(@monetary_transaction)
    end

    assert_redirected_to monetary_transactions_url
  end
end
