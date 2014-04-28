class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @contribution = Contribution.new(amount_cents: 1000)
  end

  def create
    @contribution = Contribution.new(params[:contribution])
    if params[:contribution][:monthly] == "1"
      if @contribution.create_plan_and_process_payment
        redirect_to root_path, :flash => { :notice => "Payment accepted" }
      else
         render :new, :error => { :notice => "Your donation was not accepted" }
      end
    else
      if @contribution.process_one_time_gift
        redirect_to root_path, :flash => { :notice => "Payment accepted" }
      else
        render :new, :error => { :notice => "Your donation was not accepted" }
      end
    end
  end

  private

end
