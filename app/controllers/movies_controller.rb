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
    redir = false #variable which will  be set true if redirection required
    @all_ratings = Movie.ratings

    if params[:ratings]
      @choosen_ratings = params[:ratings]
    elsif session[:ratings]
      @choosen_ratings = session[:ratings]  #choosing session ratings if no params ratings
      redir = true   
    end
    
    if params[:order]
      @order = params[:order]
    elsif session[:order]
      @order =  session[:order]   #choosing session order if no params order
      redir = true
    end
      
    session[:order] = @order
    session[:ratings] = @choosen_ratings
    if redir
      redirect_to movies_path(:order => session[:order] , :ratings => session[:ratings])  #redirecting passing the session parameters
    end
 
    if @choosen_ratings
      @movies = Movie.where(rating: session[:ratings].keys) #filtering done based on ratings
    else
      @choosen_ratings = @all_ratings
      @movies = Movie.all
    end
      
    if @order
      @movies = @movies.order(@order).all #filtering based on order
    end
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
