class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = Movie.ratings
    if ( params[:order].nil? && params[:ratings].nil? &&
        (!session[:order].nil? || !session[:ratings].nil?) )
      redirect_to movies_path(:order => session[:order], :ratings => session[:ratings])
    end
    @order = params[:order]
    @ratings = params[:ratings] 
    if !(params[:ratings].nil?)
      @movies = Movie.where(rating: params[:ratings].keys)
      @choosen_ratings = params[:ratings].keys
    else
      @choosen_ratings = @all_ratings
      @movies = Movie.all
    end
    session[:order] = @order
    session[:ratings] = @ratings
    if !params[:order].nil?
      @movies = @movies.order(params[:order]).all
    end
    
    '''
    @all_ratings = Movie.ratings
    if !(params[:ratings].nil?)
      @choosen_ratings = params[:ratings].keys
      @movies = Movie.where(rating: params[:ratings].keys)
    else
      @choosen_ratings = @all_ratings
      @movies = Movie.all
    end
    
    if !params[:order].nil?
      @movies = @movies.order(params[:order]).all
    end
    '''
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

end
