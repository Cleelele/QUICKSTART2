class ReviewsController < ApplicationController
  before_action :set_event, only: [:new, :create, :update]
  def new
    @review = Review.new
    authorize(@review)
  end

  def create
    @review = Review.new(review_params)
    @review.event = @event
    @review.user = current_user
      if @review.save
        redirect_to event_path(@event)
      else
        render :new, status: :unprocessable_entity
      end
    authorize(@review)
  end

  def index
    @user = current_user
    @reviews = Review.all
    @reviews = policy_scope(Review)
  end

  def show
    @review = Review.find(params[:id])
    @user = current_user
    authorize(@review)
  end

  def edit
    @event = Event.find(params[:id])
    @review = Review.find(params[:event_id])
    authorize(@review)
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
    authorize(@review)
  end

  def destroy
    @review = Review.find(params[:event_id])
    @event = Event.find(params[:id])
    @review.destroy
    redirect_to event_path(@event), status: :see_other
    authorize(@review)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :user_id)
  end
end
