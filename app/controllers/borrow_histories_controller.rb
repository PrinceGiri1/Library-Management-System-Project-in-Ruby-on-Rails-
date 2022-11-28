class BorrowHistoriesController < ApplicationController
  before_action :set_borrow_history, only: [:show, :edit, :update, :destroy]

  # GET /borrow_histories
  # GET /borrow_histories.json
  def index
    @borrow_histories = BorrowHistory.all
  end

  # GET /borrow_histories/1
  # GET /borrow_histories/1.json
  def show
  end

  # GET /borrow_histories/new
  def new
    @borrow_history = BorrowHistory.new
  end

  # GET /borrow_histories/1/edit
  def edit
  end

  # POST /borrow_histories
  # POST /borrow_histories.json
  def create
    @borrow_history = BorrowHistory.new(borrow_history_params)

    respond_to do |format|
      if @borrow_history.save
        format.html { redirect_to @borrow_history, notice: 'Borrow history was successfully created.' }
        format.json { render :show, status: :created, location: @borrow_history }
      else
        format.html { render :new }
        format.json { render json: @borrow_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /borrow_histories/1
  # PATCH/PUT /borrow_histories/1.json
  def update
    respond_to do |format|
      if @borrow_history.update(borrow_history_params)
        format.html { redirect_to @borrow_history, notice: 'Borrow history was successfully updated.' }
        format.json { render :show, status: :ok, location: @borrow_history }
      else
        format.html { render :edit }
        format.json { render json: @borrow_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /borrow_histories/1
  # DELETE /borrow_histories/1.json
  def destroy
    @borrow_history.destroy
    respond_to do |format|
      format.html { redirect_to borrow_histories_url, notice: 'Borrow history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_borrow_history
      @borrow_history = BorrowHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def borrow_history_params
      params.require(:borrow_history).permit(:date, :is_special, :status)
    end
end
