class QuestionnairesController < ApplicationController
  def new
    @questionaire = Questionaire.new
    authorize(@questionnaire)
  end

  def create
<<<<<<< HEAD
    @questionaire = Questionaire.new(questionnare_params)

=======
    @questionaire = Questionaire.new(article_params)
>>>>>>> a3845b4a0e11daf902000f354edd5ee134dd4857
    respond_to do |format|
      if @questionaire.save
        format.html { redirect_to new_questionaire_path(@questionaire), notice: "Restart your questionaire" }
        format.json { render :show, status: :created, location: @questionaire }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @questionaire.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @questionaire = Questionaire.all
  end

  def destroy
    @questionaire.destroy

    respond_to do |format|
      format.html { redirect_to new_questionaire_path , notice: "Restart your questionaire" }
      format.json { head :no_content }
    end
  end
end
