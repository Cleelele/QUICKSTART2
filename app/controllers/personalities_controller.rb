class PersonalitiesController < ApplicationController
  def new
    @personality = Personality.new
    authorize(@personality)
  end

  def create
    @personality = Personality.new(personality_params)
    # set user to personality( current user )
    @personality.user = current_user
    #call set_type method pass @personality.answer
    set_type(@personality.answer)
    authorize @personality
    if @personality.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def set_type(answer)
    # case = when "answer" then "personality" x 9
    case answer
     when "Adventurous outdoor activities (1)"
      @personality.type = "Adventurous"
     when "Exploring museums and cultural sites (2)"
      @personality.type = "Culture Enthusiasts"
     when "Trying new restaurants and cuisines (3)"
      @personality.type = "Food Connoisseurs"
     when "Enjoying the nightlife and live music (4)"
      @personality.type = "Nightlife Seekers"
     when "Engaging in wellness activities and fitness (5)"
      @personality.type = "Wellness and Fitness Enthusiasts"
     when "Attending art exhibitions and performances (6)"
      @personality.type = "Arts and Performance Lovers"
     when "Spending quality time with family in kid-friendly locations (7)"
      @personality.type = "Family-Friendly"
     when "Bringing my professionalism one step further (8)"
      @personality.type = "Career-Oriented Professionals"
     when "Accessible and inclusive activities for people with disabilities (9)"
      @personality.type = "Options for Handicapped People"
     else
      @personality.type = "Unknown Type"
    end
  end


  def personality_params
    params.require(:personality).permit(:answer)
  end

  def index
    @personality = Personality.all
  end

  def destroy
    @personality.destroy

    respond_to do |format|
      format.html { redirect_to new_personality_path , notice: "Restart your questionnaire" }
      format.json { head :no_content }
    end
  end
end
