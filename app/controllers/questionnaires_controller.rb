class QuestionnairesController < ApplicationController
  def new
    authorize(@questionnaire)
  end
  def create
  end
  def index
  end
  def destroy
  end
end
