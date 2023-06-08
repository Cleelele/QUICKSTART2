class ReviewsController < ApplicationController
  def new
    @review = Review.new
    authorize(@review)
  end

  def create
    @review = Review.new(review_params)
    @review.event = @event
    @review.user = current_user
      if @review.save
        redirect_to reviews_path(@review)
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
    @review = Review.find(params[:id])
    authorize(@review)
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to @review
    else
      render :edit
    end
    authorize(@review)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to reviews_path
    authorize(@review)
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
