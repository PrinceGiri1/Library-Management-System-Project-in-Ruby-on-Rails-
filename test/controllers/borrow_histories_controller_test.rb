require 'test_helper'

class BorrowHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @borrow_history = borrow_histories(:one)
  end

  test "should get index" do
    get borrow_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_borrow_history_url
    assert_response :success
  end

  test "should create borrow_history" do
    assert_difference('BorrowHistory.count') do
      post borrow_histories_url, params: { borrow_history: { date: @borrow_history.date, is_special: @borrow_history.is_special, status: @borrow_history.status } }
    end

    assert_redirected_to borrow_history_url(BorrowHistory.last)
  end

  test "should show borrow_history" do
    get borrow_history_url(@borrow_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_borrow_history_url(@borrow_history)
    assert_response :success
  end

  test "should update borrow_history" do
    patch borrow_history_url(@borrow_history), params: { borrow_history: { date: @borrow_history.date, is_special: @borrow_history.is_special, status: @borrow_history.status } }
    assert_redirected_to borrow_history_url(@borrow_history)
  end

  test "should destroy borrow_history" do
    assert_difference('BorrowHistory.count', -1) do
      delete borrow_history_url(@borrow_history)
    end

    assert_redirected_to borrow_histories_url
  end
end
