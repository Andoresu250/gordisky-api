require "application_system_test_case"

class LoansTest < ApplicationSystemTestCase
  setup do
    @loan = loans(:one)
  end

  test "visiting the index" do
    visit loans_url
    assert_selector "h1", text: "Loans"
  end

  test "creating a Loan" do
    visit loans_url
    click_on "New Loan"

    fill_in "Amount", with: @loan.amount
    fill_in "Debt", with: @loan.debt
    fill_in "Fee value", with: @loan.fee_value
    fill_in "Fees", with: @loan.fees
    fill_in "Fees fulfilled", with: @loan.fees_fulfilled
    fill_in "Frequency", with: @loan.frequency
    fill_in "Interest", with: @loan.interest
    fill_in "Last paid", with: @loan.last_paid
    fill_in "Next paid", with: @loan.next_paid
    fill_in "Paid", with: @loan.paid
    fill_in "Person", with: @loan.person_id
    fill_in "Remaining fees", with: @loan.remaining_fees
    click_on "Create Loan"

    assert_text "Loan was successfully created"
    click_on "Back"
  end

  test "updating a Loan" do
    visit loans_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @loan.amount
    fill_in "Debt", with: @loan.debt
    fill_in "Fee value", with: @loan.fee_value
    fill_in "Fees", with: @loan.fees
    fill_in "Fees fulfilled", with: @loan.fees_fulfilled
    fill_in "Frequency", with: @loan.frequency
    fill_in "Interest", with: @loan.interest
    fill_in "Last paid", with: @loan.last_paid
    fill_in "Next paid", with: @loan.next_paid
    fill_in "Paid", with: @loan.paid
    fill_in "Person", with: @loan.person_id
    fill_in "Remaining fees", with: @loan.remaining_fees
    click_on "Update Loan"

    assert_text "Loan was successfully updated"
    click_on "Back"
  end

  test "destroying a Loan" do
    visit loans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Loan was successfully destroyed"
  end
end
