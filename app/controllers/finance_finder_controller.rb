class FinanceFinderController < ApplicationController

  def index
    @finance_supports = BusinessSupport.order_by([[:title, :asc]])
  end

end
