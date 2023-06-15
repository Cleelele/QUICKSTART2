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
    @personality.mood = set_mood(params[:personality][:answer])
    if @personality.update!(personality_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def set_mood(answer)
    # case = when "answer" then "personality" x 9
    case answer
     when "Exciting adventurous activities and outdoors fun (1) 🏄‍♀️"
      return "Adventurous"
     when "Exploring museums and cultural sites (2) 🕌🌆"
      return "Culture Enthusiasts"
     when "Trying new restaurants and cuisines (3)🍔"
      return "Food Connoisseurs"
     when "Enjoying the nightlife and live music (4) 🪩🎶"
      return "Nightlife Seekers"
     when "Engaging in wellness activities and fitness (5) 🏋️‍♀️🧖‍♀️"
      return "Wellness and Fitness Enthusiasts"
     when "Attending art exhibitions and performances (6) 🎨🎭"
      return "Arts and Performance Lovers"
     when "Spending quality time with family in kid-friendly locations (7) 👨‍👩‍👧‍👦"
      return "Family-Friendly"
     when "Bringing my professionalism one step further (8) 🧑‍⚖️👩‍🎓"
      return "Career-Oriented Professionals"
     when "Accessible and inclusive activities for people with disabilities (9)🧑‍🦽🧑‍🦯"
      return "Options for Handicapped People"
     else
      return "Unknown Type"
    end
  end


  def personality_params
    params.require(:personality).permit(:answer)
  end

end
