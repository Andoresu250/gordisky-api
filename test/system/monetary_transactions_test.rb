require "application_system_test_case"

class MonetaryTransactionsTest < ApplicationSystemTestCase
  setup do
    @monetary_transaction = monetary_transactions(:one)
  end

  test "visiting the index" do
    visit monetary_transactions_url
    assert_selector "h1", text: "Monetary Transactions"
  end

  test "creating a Monetary transaction" do
    visit monetary_transactions_url
    click_on "New Monetary Transaction"

    fill_in "Description", with: @monetary_transaction.description
    fill_in "Mode", with: @monetary_transaction.mode
    fill_in "Value", with: @monetary_transaction.value
    click_on "Create Monetary transaction"

    assert_text "Monetary transaction was successfully created"
    click_on "Back"
  end

  test "updating a Monetary transaction" do
    visit monetary_transactions_url
    click_on "Edit", match: :first

    fill_in "Description", with: @monetary_transaction.description
    fill_in "Mode", with: @monetary_transaction.mode
    fill_in "Value", with: @monetary_transaction.value
    click_on "Update Monetary transaction"

    assert_text "Monetary transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Monetary transaction" do
    visit monetary_transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Monetary transaction was successfully destroyed"
  end
end
