class HomesController < ApplicationController
  before_action :authenticate_user!
  def index
    @ten_financial_transaction = current_user.ten_financial_transaction
  end
end
