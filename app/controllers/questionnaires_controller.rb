class QuestionnairesController < ApplicationController
  def new
    @questionaire = Questionaire.new
  end

  def create
    @article = Article.new(article_params)

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
