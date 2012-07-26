class FinanceFinderController < ApplicationController

  def index
    @finance_supports = BusinessSupport.all
  end

end
