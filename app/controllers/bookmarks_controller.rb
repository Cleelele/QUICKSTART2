class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
    authorize(@bookmark)
  end

  def create
    @bookmark = Bookmark.new
    @bookmark.user = current_user
    event_id = params[:event_id]
    @bookmark.event = Event.find(event_id)
    if @bookmark.save
      redirect_to bookmarks_path(@bookmark)
    else
      render :new, status: :unprocessable_entity
    end
    authorize(@bookmark)
  end

  def index
    @bookmarks = policy_scope(Bookmark)
    @user = current_user
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path, status: :see_other
    authorize(@bookmark)
  end
end
