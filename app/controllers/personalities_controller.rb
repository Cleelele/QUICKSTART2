class PersonalitiesController < ApplicationController

  def new
    @personality = Personality.new
    authorize @personality
  end

  def create
    @personality = Personality.new(personality_params)
    # set user to personality( current user )
    @personality.user = current_user
    #call set_type method pass @personality.answer
    set_mood(@personality.answer)
    authorize @personality
    if @personality.save!
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @personality = Personality.find(params[:id])
    authorize @personality
  end

  def update
    @personality = Personality.find(params[:id])
    authorize @personality
    @user = current_user
    @personality.user = current_user
    #call set_type method pass @personality.answer
    set_mood(@personality.answer)
    if @personality.update(personality_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def set_mood(answer)
    # case = when "answer" then "personality" x 9
    case answer
     when "Adventurous outdoor activities (1)"
      @personality.mood = "Adventurous"
     when "Exploring museums and cultural sites (2)"
      @personality.mood = "Culture Enthusiasts"
     when "Trying new restaurants and cuisines (3)"
      @personality.mood = "Food Connoisseurs"
     when "Enjoying the nightlife and live music (4)"
      @personality.mood = "Nightlife Seekers"
     when "Engaging in wellness activities and fitness (5)"
      @personality.mood = "Wellness and Fitness Enthusiasts"
     when "Attending art exhibitions and performances (6)"
      @personality.mood = "Arts and Performance Lovers"
     when "Spending quality time with family in kid-friendly locations (7)"
      @personality.mood = "Family-Friendly"
     when "Bringing my professionalism one step further (8)"
      @personality.mood = "Career-Oriented Professionals"
     when "Accessible and inclusive activities for people with disabilities (9)"
      @personality.mood = "Options for Handicapped People"
     else
      @personality.mood = "Unknown Type"
    end
  end


  def personality_params
    params.require(:personality).permit(:answer)
  end

end
