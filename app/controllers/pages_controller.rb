class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      if current_user.personality.nil?
        redirect_to new_personality_path
      else
        redirect_to events_path
      end
    end
  end

  def profile
    @user = current_user
  end

end
