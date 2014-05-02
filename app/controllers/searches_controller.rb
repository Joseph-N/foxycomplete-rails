class SearchesController < ApplicationController
  def index
  end

  def search
  	# call custom json function with query and limit params
	results = custom_json(params[:q], params[:limit])
	# return json format
  	render json: results
  end

  private

  def custom_json(query, max)
  	# invoke the youtube api and pass in query and limit the maxResults returned
  	results = RestClient.get "https://www.googleapis.com/youtube/v3/search", {
  		:params => {
  			:q => query,
  			:maxResults => max,
  			:part => "snippet",
  			:type => "video",
  			:key => ENV["YOUTUBE_KEY"]
  			}
  		}
  	# parse the results into json and assign them to data
  	data = JSON.parse(results)

  	# parse only data we need and format it so that foxycomplete is able to inteprete it correctly
  	#in JSON format. (FoxyComplete needs a title, image and permalink)
  	data["items"].collect do |info|
  		{
  			:title => info["snippet"]["title"],
  			:image => info["snippet"]["thumbnails"]["default"]["url"],
  			:permalink => "https://www.youtube.com/watch?v=" + info["id"]["videoId"]
  		}
  	end.to_json
  end
end
