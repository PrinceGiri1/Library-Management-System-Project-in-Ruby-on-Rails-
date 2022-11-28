require "application_system_test_case"

class BorrowHistoriesTest < ApplicationSystemTestCase
  setup do
    @borrow_history = borrow_histories(:one)
  end

  test "visiting the index" do
    visit borrow_histories_url
    assert_selector "h1", text: "Borrow Histories"
  end

  test "creating a Borrow history" do
    visit borrow_histories_url
    click_on "New Borrow History"

    fill_in "Date", with: @borrow_history.date
    check "Is special" if @borrow_history.is_special
    fill_in "Status", with: @borrow_history.status
    click_on "Create Borrow history"

    assert_text "Borrow history was successfully created"
    click_on "Back"
  end

  test "updating a Borrow history" do
    visit borrow_histories_url
    click_on "Edit", match: :first

    fill_in "Date", with: @borrow_history.date
    check "Is special" if @borrow_history.is_special
    fill_in "Status", with: @borrow_history.status
    click_on "Update Borrow history"

    assert_text "Borrow history was successfully updated"
    click_on "Back"
  end

  test "destroying a Borrow history" do
    visit borrow_histories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Borrow history was successfully destroyed"
  end
end
