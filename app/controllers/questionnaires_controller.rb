class QuestionnairesController < ApplicationController
  def new
    @questionnaire = Questionnaire.new
    authorize(@questionnaire)
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)

    respond_to do |format|
      if @questionaire.save
        format.html { redirect_to new_questionnaire_path(@questionnaire), notice: "Restart your questionnaire" }
        format.json { render :show, status: :created, location: @questionnaire }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @questionnaire = Questionnaire.all
  end

  def destroy
    @questionnaire.destroy

    respond_to do |format|
      format.html { redirect_to new_questionnaire_path , notice: "Restart your questionnaire" }
      format.json { head :no_content }
    end
  end


end
