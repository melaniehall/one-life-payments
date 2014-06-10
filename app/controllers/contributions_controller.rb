class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = Contribution.new(amount_cents: "")
  end

  def create
    @contribution = Contribution.new(params[:contribution])
    if @contribution.process_payment
      redirect_to thank_you_path
    else
      render :new
    end
  end

  def index
    redirect_to new_contribution_path
  end

  private

end
