class HomesController < ApplicationController
  before_action :authenticate_user!
  def index
    @ten_financial_transaction = current_user.ten_financial_transaction
  end

  def edit
    @sources = Source.all.select(:id, :email, :subject)
  end
end
