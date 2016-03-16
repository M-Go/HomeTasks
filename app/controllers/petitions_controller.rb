class PetitionsController < ApplicationController

  def index
    @petitions = Petition.all
    if params[:my]
      @petitions = @petitions.where(user: current_user)
      render 'my_index'
    end
  end

  def show
    @petition = Petition.find(params[:id])
    render 'view_petition'
  end

  def new
    @petition = Petition.new
  end

  def create
    petition = current_user.petitions.create(petition_params)
    redirect_to petition_path(petition)
  end

  def update
    petition = current_user.petitions.find(params[:id])
    petition.update(petition_params)
    redirect_to petition_path(petition), notice: 'Петиция обновлена'
  end

  def destroy
    petition = current_user.petitions.find(params[:id])
    petition.destroy
    redirect_to action: :index, notice: 'Петиция удалена'
  end

  private
  def petition_params
    params.require(:petition).permit(:title, :description)
  end

end