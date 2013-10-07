class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
 
    @all_ratings = Movie.ratings
    @hilite = params[:hilite]
    @ratings_hash = params[:ratings]

    if @ratings_hash.nil?
      @ratings_hash = session[:ratings]
      if @ratings_hash.nil?
        @ratings_hash = Hash.new
        @ratings = @all_ratings
      else
        @ratings = @ratings_hash.keys
      end
    else
      @ratings = @ratings_hash.keys
    end
    if @hilite.nil?
      @hilite = session[:hilite]
    end

    if (@hilite == 'release_date')
      @movies = Movie.find(:all, :conditions =>{:rating => @ratings}, :order => "release_date")
    end
    if (@hilite == 'title')
     @movies = Movie.find(:all, :conditions =>{:rating => @ratings}, :order => "title")
    else
      @movies = Movie.find(:all, :conditions =>{:rating => @ratings})
    end
    session[:hilite] = @hilite
    session[:ratings] = @ratings_hash
   if params[:ratings].nil? or params[:hilite].nil?
    flash.keep
    redirect_to movies_path(:hilite => @hilite, :ratings => @ratings_hash)
   end
  end

  def new
    # default: render 'new' template
  end


  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
