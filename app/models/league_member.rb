class LeagueMember < ApplicationRecord
  belongs_to :user
  belongs_to :league

  after_create :create_ranking

  private

  def create_ranking
    Ranking.create(league_id: league_id, user_id: user_id)
  end
end
