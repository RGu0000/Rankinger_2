class LeaguesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    @league.owner_id = current_user.id
    if @league.save
      flash[:success] = 'League created.'
      redirect_to @league
    else
      flash[:danger] = 'Could not create new league.'
      render 'new'
    end
  end

  def edit
    @league = League.find(params[:id])
  end

  def update
    @league = League.find(params[:id])
    if @league.update_attributes(league_params)
      flash[:success] = 'League edited.'
      redirect_to @league
    else
      flash[:danger] = 'Could not edit league.'
      render 'edit'
    end
  end

  def destroy
    League.find(params[:id]).destroy
    flash[:success] = 'League deleted.'
    redirect_to leagues_path
  end

  def join
    @league = League.find(params[:id])
    if not_full?(@league)
      if @league.users.include? current_user
        flash[:danger] = 'You already belong to this league.'
      else
        flash[:success] = "Welcome to #{@league.name}"
        @league.users << current_user
        LeagueServices::MatchesGenerator.new(league: @league).call if @league.users.count == @league.capacity
      end
    else
      flash[:danger] = 'This league is already full'
    end
    redirect_to @league
  end

  def kick
    @league = League.find(params[:league_id])
    @user = User.find(params[:user_id])
    @league.users.delete(@user)
    flash[:success] = "#{@user.name} successfully deleted."
    redirect_to @league
  end

  private

  def league_params
    params.require(:league).permit(:name, :description, :capacity)
  end

  def not_full?(league)
    league.users.count < league.capacity
  end
end
