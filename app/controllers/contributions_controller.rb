class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = Contribution.new(amount_cents: 1000)
  end

  def create
    @contribution = Contribution.new(params[:contribution])
    if @contribution.process_payment
      redirect_to root_path, :flash => { :notice => "Your donation was accepted" }
    else
      render :new, :flash => { :error => "Your donation was not accepted" }
    end
  end

  private

end
