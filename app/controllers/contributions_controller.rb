class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = Contribution.new(amount_cents: 1000)
  end

  def create
    @contribution = Contribution.new(params[:contribution])
    if @contribution.process_payment
      redirect_to thank_you_path
    else
      #redirect_to card_errors_path
      render :new
    end
  end

  private

end
