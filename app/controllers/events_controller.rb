class EventsController < ApplicationController
  include PersonalityHelper

  def new
  end

  def create
    @event = Event.new(event_params)
    @event.price = event_params[:price].to_i
    @event.name = event_params[:name]
    @event.description = event_params[:description]
    @event.category = event_params[:category]
    @event.address = event_params[:address]
    @event.image = event_params[:image]
    authorize @event

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event) }
        format.json { render json: { redirect_to: event_path(@event) } }
      else
        format.json { render json: { error: 'Failed to create event', errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def index
    #personalityType = getUserPersonalityType
    #matchingTags = getMatchingTagsForPersonalityType(personalityType)
    @events = policy_scope(Event)
    @bookmark = Bookmark.new
    @user = current_user
    if user_signed_in?
      if current_user.personality.nil?
        flash[:error] = 'Please complete the question to continue'
        redirect_to new_personality_path
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    @user = current_user
    @markers = @event.geocode.map do |event|
      {
        lat: @event.latitude,
        lng: @event.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { event: @event })
      }
    end
    authorize(@event)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def event_params
    params.require(:event).permit(:name, :price, :address, :description, :category, :image)
  end
end
