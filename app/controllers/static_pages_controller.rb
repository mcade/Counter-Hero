class StaticPagesController < ApplicationController
  require 'net/http'
  def home

  end

  def faq
  end

  def counterinfo
    @ids = params[:ids]
    @matchesarray = []
    @namesarray = []
    @gpmarray = []
    @marray = ['Apple', 'Banana', 'Orange']

    @killsarray = []
    @deathsarray = []
    @assistsarray = []
    @herodmgarray = []
    @towerdmgarray = []
    @heroidarray = []
    @levelarray = []
    @wlarray = []

    @idarray = @ids.scan(/\[U:\d:(\d+)\]/).map { |i| i.first.to_i }
    @idarray.each do |playerid| 
      steam64Bit = playerid + 76561197960265728
      url = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?matches_requested=1&key=#{ENV['STEAM_WEB_API_KEY']}&account_id=#{steam64Bit}")
      res = Net::HTTP::get(url)

      if JSON.parse(res)['result']['status'] != 15
        @matchlist = JSON.load(res)['result']['matches']
        @matchlist.each do |match|
          puts match['match_id']
          @matchesarray << match['match_id']
          matchid = match['match_id']
          url3 = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=#{matchid}&key=#{ENV['STEAM_WEB_API_KEY']}")
          res3 = Net::HTTP::get(url3)
          @matchdetails = JSON.load(res3)['result']['players']
          @matchdetails.each do |detail|
            if detail['account_id'] == playerid
              @gpmarray << detail['gold_per_min']
              @killsarray << detail['kills']
              @deathsarray << detail['deaths']
              @assistsarray << detail['assists']
              @herodmgarray << detail['hero_damage']
              @towerdmgarray << detail['tower_damage']
              @heroidarray << detail['hero_id']
              @levelarray << detail['level']
              if detail['player_slot'] == 0 || detail['player_slot'] == 1 || detail['player_slot'] == 2 || detail['player_slot'] == 3 || detail['player_slot'] == 4
                if JSON.parse(res3)['result']['radiant_win'] == true
                  @wlarray << 'W'
                else
                  @wlarray << 'L'
                end
              else
                if JSON.parse(res3)['result']['radiant_win'] == true
                  @wlarray << 'L'
                else
                  @wlarray << 'W'
                end
              end 
            end
          end
        end

        url2 = URI.parse("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV['STEAM_WEB_API_KEY']}&steamids=#{steam64Bit}")
        res2 = Net::HTTP::get(url2)
        @playernames = JSON.load(res2)['response']['players']
        @playernames.each do |name|
          @namesarray << name['personaname']
        end
        

        
      else
        @namesarray << 'anon'
        @matchesarray << 0
        @gpmarray << 0
        @killsarray << 0
        @deathsarray << 0
        @assistsarray << 0
        @herodmgarray << 0
        @towerdmgarray << 0
        @heroidarray << 0
        @levelarray << 0
        @wlarray << '-'
      end
      @totaldmgarray = [@herodmgarray,@towerdmgarray].transpose.map {|x| x.reduce(:+)}
    end

  end

end
