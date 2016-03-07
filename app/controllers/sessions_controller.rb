class SessionsController < ApplicationController
  def index
    render json: session
  end

  def show
    session['id'] = params[:id]
    render json: params[:id]
  end

  def new

  end

  def create

  end

  def update

  end

  def destroy

  end
end