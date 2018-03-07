# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
# Match.where( "matches.player_1 = ? OR matches.player_2 = ? ", user.id, user.id)
# Match.where(player_1: user).or(Match.where(player_2: user))
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Helpers:
names = %w[Rysiek Dominika Kacper Bartosz Zuza Ozim Robert Kanapka Obiad Amator haslo_to_111111]
league_names = %w[Pusta_liga 1_gracz 2_graczy 3_graczy 4_graczy 5_graczy 6_graczy 7_graczy 8_graczy 9_graczy 10_graczy]
descriptions = %w[Fajna_liga Super_liga Liga_mistrzow Ekstraklasa Poznan_Rulez
                 Bialystok Warszawa Gdansk Krakow Katowice Liga_Amatorow]
pass = 111111

# Create Users:
names.map{ |name| User.create(email: "#{name}@pl",
                                       password: pass,
                                       password_confirmation: pass,
                                       name: name) }
users = User.all

league_names.each_with_index do |league_name, index|
  #binding.pry
  # Create leagues:
  League.create(name: league_name,
                description: descriptions[index],
                capacity: index,
                owner_id: index+1)

  # Create LeagueMembers:
  league = League.all[index]
  league.capacity.times do |j|
    LeagueMember.create(user_id: users[j].id, league_id: index+1)
  end

  # Generate matches:
  LeagueServices::MatchesGenerator.new(league: league).call

end

League.create(name: "20",
              description: "20 users",
              capacity: 20,
              owner_id: 1)
20.times do |i|
  User.create(email: "#{i}@pl",
              password: pass,
              password_confirmation: pass,
              name: i)

  LeagueMember.create(user_id: User.last.id, league_id: League.last.id)
end

  LeagueServices::MatchesGenerator.new(league: League.last).call
