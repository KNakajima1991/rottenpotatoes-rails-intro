class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    allmovies=Hash.new
    for ratings in Movie.all_ratings
      allmovies[ratings]="1"
    end
    #print(allmovies)
    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif params[:utf8]
      session[:ratings]=allmovies
    elsif session[:ratings].nil?
      session[:ratings] = Hash.new
    end

    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort].nil?
      session[:sort] = Hash.new
    end
    
    @ratings_to_show = session[:ratings]
    if params[:utf8] and !params[:ratings]
      @ratings_to_show=[]
    end
    
    #@ratings_to_show = @ratings
    @all_ratings = Movie.all_ratings
    
    @movie=Movie.all
    @movie = Movie.where(:rating => session[:ratings].keys)
    @movie = @movie.order(session[:sort])

  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
