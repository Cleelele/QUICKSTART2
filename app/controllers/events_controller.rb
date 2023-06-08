class EventsController < ApplicationController
  def new
  end

  def create
  end

  def index
    @events = policy_scope(Event)
    @bookmark = Bookmark.new
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
end
