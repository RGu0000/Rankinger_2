class MatchesController < ApplicationController
  before_action :set_match, only: %i[edit update]

  def index
    @matches = Match.with_players(:player1, :player2)
  end

  def edit
    @match = Match.find(params[:id])
    @player1 = User.find_by(id: @match.player1)
    @player2 = User.find_by(id: @match.player2)
  end

  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      flash[:success] = 'Score updated.'
    else
      flash[:danger] = 'Could not update score.'
    end
    RankingServices::RankingUpdater.new(match: @match).call
    redirect_to league_path(@match.league.id)
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:player1_goals, :player2_goals)
  end
end
