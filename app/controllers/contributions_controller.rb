class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = current_user.contributions.build(amount_cents: 1000)
  end

  def create
    # if a current user is signed in it will set them as the user for this contribution.
    @contribution = current_user.contributions.build(params[:contribution])
    if @contribution.process_payment
      @contribution.save
      redirect_to root_path, :flash => { :notice => "Payment accepted" }
    else
      redirect_to root_path, :error => { :notice => "Your donation was not accepted" }
    end
  end

  private

end
