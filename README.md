-->![Animated GIF of Movie Search](https://github.com/worldviewer/rails-omdb/blob/master/rails-omdb.gif)<--

# Challenges I Ran Into with this Project:

1. I wanted to be helpful with the search box, but **it was difficult to find a list of the best-rated movies in a tab- or comma-separated format**.  With some searching, I found that somebody had already done the scraping, and placed the results here: 

 [Two-Fifty: Track Movies Watched on the IMDb Top 250](http://code.google.com/p/two-fifty/source/browse/trunk/imdb-10000.csv)

2. That file required some cleanup.  First of all, **it had a varying number of columns**, because not every film had a genre, so I did a regular expressions search with Sublime to replace the specific situation where no genre is listed with "No genre listed".

3. **There were non-ASCII characters in many of the foreign film names** (and even some of the American titles).  So, I used Sublime to clean up the data, by doing a Regular Expression search on

 ```
 [^\x00-\x7F]
 ```

 Around 50 of these titles were just completely indecipherable, so I deleted them out of the list.

4. One problem I ran into was that **the typeahead javascript I was using required data to be in a hash format**:

 ```
 [ { value:"title", value:"title" }, ... ]
 ```

 I decided to see what was available in terms of JavaScript code that would automatically convert a tab-separated value (TSV) file into this hash.  I found this:

 [jquery-tsv, Tab-separated values plugin for jQuery](http://code.google.com/p/jquery-tsv/)

 And once I was passing a properly-formatted string to it, I got it to work!

5. Another issue I ran into was with **Rails' form generator: It appears to somewhat conflict with the typeahead.js and bloodhound.js combination that I used to implement typeahead, insofar as there appear to be two separate text inputs that are on top of one another, and which are redundant**.

 _Question: Is it possible to override Rails form generator without breaking Rails security?_

6. Something else I observed was that **the gem I installed for this project**, at ...

 [Bootstrap Typeahead for Rails](http://github.com/Nerian/bootstrap-typeahead-rails)

 **This gem did not really appear to accomplish much beyond the installation of files into app directory** bower_components/typeahead.js.  I had to move the assets myself into the assets/javascripts/ directory, and the example in test/ did not walk me through the process of increasing complexity with typeahead, as other sites do, like these two do:

 [Typeahead.js Autocomplete Suggestion and Bloodhount Remote Data - Tutorial and Demo](http://mycodde.blogspot.com/2014/12/typeaheadjs-autocomplete-suggestion.html)

 [Twitter's typeahead.js Examples on Github](twitter.github.io/typeahead.js/examples/)

If I could do this project over again, I would:

1. Time permitting, **try to use Awk at the command-line to do the data pre-processing**.  There is a new Awk book here, from 2015:

 [Effective awk Programming: Universal Text Processing and Pattern Matching](http://www.amazon.com/Effective-awk-Programming-Universal-Processing/dp/1491904615/ref=pd_sim_b_7?ie=UTF8&refRID=0GWFY4MZXTD8ZNY49CB1)

 This data processing text dives into a very similar IMDb situation ...

 [Data Science at the Command Line: Facing the Future with Time-Tested Tools](http://books.google.com/books?id=yMSeBAAAQBAJ&pg=PA33&lpg=PA33&dq=top+250+imdb+movies+comma+separated+values&source=bl&ots=2PtuzvT83u&sig=FxcHSSK1hvgcSRrICY7wT04bu7w&hl=en&sa=X&ei=q0tGVZewEI3VoASNnICgDQ&ved=0CDgQ6AEwBA#v=onepage&q=top%20250%20imdb%20movies%20comma%20separated%20values&f=false)

2. I'd really like to take this project to a more practical level by using **AJAX to source the data from the server side**.  This would have the added benefit of allowing me to use a template to set up the typeahead values, and that would permit me to display the genre, year made and IMDb ratings alongside the titles.

# The Project: Using an API with Ruby and Rails

Objectives
Students will be able to...

1. Use Typhoeus, a ruby gem, to make HTTP requests to API's.
2. Parse the data returned by the API.
3. Use the data to create Dynamic content in a Rails app.

## Getting Started

The goal of the lab is to get comfortable with rails, api calls and json. By the end of the lab, you should have an app that uses routes, forms, and an api call that returns json.

Start a new Rails app by running the command `rails new omdb_app` and then `cd` into the app.

### Making HTTP Requests: [Typhoeus](https://github.com/typhoeus/typhoeus)

Check out the [Typhoeus](https://github.com/typhoeus/typhoeus) documentation and attempt to add Typhoeus to your rails project.

To check that you've done everything appropriately, run `rails c` and try making the function call

```bash
> Typhoeus.get("www.google.com")
```

Query parameters can be passed along like this

```bash
> response = Typhoeus.get("www.google.com", :params => {:name => "Tim" })
```

If you get any output then all is good in the world and Typhoeus is installed. To access the body of the request that we get back from Typhoeus we use the `.body` method on a request. Like this

```bash
> resp = Typhoeus.get("http://www.reddit.com/new.json")
> json_resp = JSON.parse(resp.body)
```

This gives us the body of the request.

### OMDB
The two routes, we're going to need

Number 1: http://www.omdbapi.com?s=SEARCH+TERM+PLUS+DELIMITED. This important part from the link above is the ?s=SEARCH+TERM+PLUS+DELIMITED. An example of a query we're going to make. [http://www.omdbapi.com?s=i+robot](http://www.omdbapi.com?s=i+robot).

This makes a GET request where we're searching for a particular movie title.

Number 2: http://www.omdbapi.com?i=IMDBID. This important part from the link above is the ?i=IMDBID. An example of a query we're going to make. [http://www.omdbapi.com?i=tt1083849](http://www.omdbapi.com?i=tt1083849).

This makes a GET request where we're searching for a particular movie with that IMDB ID.

**Exercise:** Use Typhoeus to make requests to each of these URLs.

Note: Be use to use `JSON.parse` on the body of the responses we get back from Typhoeus. If we forget to do this, the reponse we get back will be a string.



## Add Two Routes to our `routes.rb` file in the `config` directory. Additionally you'll need to generate a search controller and any required views. `rails g controller search`.

#### Search Route

Create a route for `/search`. This route should correspond to the `search#index` action and will allow our user to search for movies.

The `GET` route will present the user with a form - a search box.

```html
<%= form_tag("/search", method: "get") do %>
  <%= label_tag(:q, "Search for:") %>
  <%= text_field_tag(:q) %>
  <%= submit_tag("Search") %>
<% end %>
```

When the user submits a search, it'll make a request to our app's search route:
```
GET /search?q=users+search+terms
```

The app will make a request to the OMDB API with the user's search terms, and return these results to the user displaying the results.

#### Movie Info Route

Now that we've given the user a list of movies for their search, let's give them some info on the movies themselves.

When the user clicks on a movie title, we want to present a page with some details on the movie.

Create a route `/movie` and corresponding controller action and views for this information. We'll get the movie title from a query param containing the IMDB ID. For example, to get information on the movie "No Country for Old Men", you'd make a request to:

```
GET /movie?q=tt0477348
```

Our app needs to make a request to the OMDB API for the movie with this ID and present the user with an HTML page containing these results.

[Solution](https://github.com/sf-wdi-17/rails_apis_lesson)
