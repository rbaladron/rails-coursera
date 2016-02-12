class MoviePagesController < ApplicationController
  before_action :set_movie, only: [:edit, :update, :destroy]
  before_action :set_cached_movie, only: [:show]
  caches_page :index, :show

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
    fresh_when last_modified: @movies.max(:updated_at)
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
#    headers["ETag"]=Digest::MD5.hexdigest(@movie.cache_key) 
#    headers["Last-Modified"]=@movie.updated_at.httpdate
#    fresh_when(@movie)
    @movie.movie_accesses.create(:action=>"cached-page#show")
    if stale? @movie
      @movie.movie_accesses.create(:action=>"cached-page#show-stale")
      #do some additional, expensive work here

      secs=10
      response.headers["Expires"] = secs.seconds.from_now.httpdate
#     response.headers["Cache-Control"] = "public, max-age=#{secs}"
      expires_in secs.seconds, :public=>true
    end
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        fresh_when(@movie)
        @movie.movie_accesses.create(:action=>"create")
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        expire_page action: "show", id:@movie, format: request.format.symbol
        expire_page action: "index", format: request.format.symbol
        fresh_when(@movie)
        @movie.movie_accesses.create(:action=>"update")
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.movie_accesses.create(:action=>"destroy")
    @movie.destroy
    expire_page action: "show", id:@movie, format: request.format.symbol
    expire_page action: "index", format: request.format.symbol
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def set_cached_movie
      @@page_cache_directory ||= Rails.application.config.action_controller.page_cache_directory
      uri="/movie_pages/#{params[:id]}.#{request.format.symbol}"
      file_path="#{@@page_cache_directory}/#{uri}"
      if File.exists?(file_path)
        redirect_to "/page_cache#{uri}"
      else
        Rails.logger.debug("cached file #{file_path} not found")
        set_movie
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:id, :title, :updated_at)
    end
end
