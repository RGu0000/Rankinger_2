class LeaguesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :require_permission, only: %i[edit destroy]
  before_action :require_kick_permission, only: [:kick]

  def index
    @leagues = League.includes(:owner)
  end

  def show
    @league = League.find(params[:id]).decorate
    @matches = @league.matches.includes(:player1, :player2).decorate
    @ranking = Ranking.league_ranking(@league.id).includes(:user)
                      .sort { |first, second| second.points <=> first.points }
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

  def require_permission
    league = League.find_by(id: params[:id])
    return redirect_to root_path unless league.present?

    if current_user == league.owner
    elsif current_user != league.owner
      redirect_to root_path, message: 'woo'
    end
  end

  def require_kick_permission
    league = League.find_by(id: params[:league_id])
    return redirect_to root_path unless league.present?

    if current_user == league.owner || current_user == User.find(params[:user_id])
    elsif current_user != league.owner
      redirect_to root_path, message: 'woo'
    end
  end

  def league_params
    params.require(:league).permit(:name, :description, :capacity)
  end

  def not_full?(league)
    league.users.count < league.capacity
  end
end
