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
    @personality.mood = set_mood(@personality.answer)
    
    authorize @personality
    if @personality.save
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
    @personality.answer = personality_params[:answer]
    @personality.mood = set_mood(@personality.answer)
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
     when "Adventurous outdoor activities (1) 🏄‍♀️"
      return "adventurous explorer"
     when "Exploring museums and cultural sites (2) 🕌🌆"
      return "culture enthusiasts"
     when "Trying new restaurants and cuisines (3)🍔"
      return "food connoisseur"
     when "Enjoying the nightlife and live music (4) 🪩🎶"
      return "nightlife seekers"
     when "Engaging in wellness activities and fitness (5) 🏋️‍♀️🧖‍♀️"
      return "wellness and fitness enthusiast"
     when "Attending art exhibitions and performances (6) 🎨🎭"
      return "arts and performance lover"
     when "Spending quality time with family in kid-friendly locations (7) 👨‍👩‍👧‍👦"
      return "family friendly"
     when "Bringing my professionalism one step further (8) 🧑‍⚖️👩‍🎓"
      return "career oriented professional"
     when "Accessible and inclusive activities for people with disabilities (9)🧑‍🦽🧑‍🦯"
      return "handicapped person"
     else
      return "Unknown Type"
    end
  end


  def personality_params
    params.require(:personality).permit(:answer, :mood)
  end

end
