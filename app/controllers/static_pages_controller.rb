class StaticPagesController < ApplicationController
  def home
  	@counterinfo = Counterinfo.new
    #@counterinfo = counterinfos.build
    url = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=841615883&key=#{ENV['STEAM_WEB_API_KEY']}")
    #url = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=#{ENV['STEAM_WEB_API_KEY']}&matches_requested=1")
  	#url = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?matches_requested=1&key=#{ENV['STEAM_WEB_API_KEY']}&account_id=76561198033974572")
    res = Net::HTTP::get(url)
    @matchlist = JSON.load(res)['result']['players']

  end

  def faq
  end

  def counterinfo
    @ids = params[:ids]
    @matchesarray = []
    @namesarray = []
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
        end

        url2 = URI.parse("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV['STEAM_WEB_API_KEY']}&steamids=#{steam64Bit}")
        res2 = Net::HTTP::get(url2)
        @playernames = JSON.load(res2)['response']['players']
        @playernames.each do |name|
          @namesarray << name['personaname']
        end
        

        sleep 1.0
      else
        @namesarray << 'anon'
        @matchesarray << 0
      end
    end
    puts @namesarray
  end

   private
    # Use callbacks to share common setup or constraints between actions.
    #def set_thing
    #  @thing = Thing.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def counterinfo_params
      params.require(:counterinfo).permit(:content)
    end
end
