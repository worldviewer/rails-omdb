class SearchController < ApplicationController
	def index
		search_params = params[:q]

		if search_params
			resp = Typhoeus.get('http://www.omdbapi.com',
				params: {s: search_params})
			@movies = JSON.parse(resp.body)["Search"]
		else
			@movies = []
		end
	end

	# Accept movie search, submit that search to
	# OMDB, return and display list of movies
	# on the same erb page
	def movie
		movie_params = params[:q]
		if movie_params
			resp = Typhoeus.get("http://www.omdbapi.com", params: {i: movie_params})
			@movie = JSON.parse(resp.body)
		else
			@movie = {}
		end
	end
end
