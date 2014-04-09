class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = current_user.contributions.build(amount_cents: 1000)
  end

  def create
    # if a current user is signed in it will set them as the user for this contribution.
    @contribution = current_user.contributions.build(params[:contribution])
    if params[:contribution][:sender_id].present?
      render :new, :error => { :notice => "Your donation was not accepted" }
    end
    if params[:contribution][:monthly] == "1"
      @contribution.create_plan_and_process_payment
    end
    if @contribution.process_one_time_gift
      @contribution.save
      redirect_to root_path, :flash => { :notice => "Payment accepted" }
    else
      render :new, :error => { :notice => "Your donation was not accepted" }
    end
  end

  private

end
