module Api
  class MoviesController < Api::BaseController
    before_action :set_movie, only: [:show, :edit, :update, :destroy]

    def index
      respond_with Movie.all
    end
    def show
      respond_with @movie
    end
    def create
      respond_with Movie.create(movie_params)
    end
    def update
      respond_with @movie.update(movie_params)
    end
    def destroy
      respond_with @movie.destroy
    end

    private
      def set_movie
        @movie = Movie.find(params[:id])

        rescue Mongoid::Errors::DocumentNotFound => e
          respond_to do |format|
            format.json { render json: {msg:"movie[#{params[:id]}] not found"}, status: :not_found }
          end
      end
      def movie_params
        email=current_user.email  if current_user
        params.require(:movie).permit(:id, :title).merge({:last_modifier=>email})
      end

      def current_user
        unless @current_user
          if doorkeeper_token && doorkeeper_token.resource_owner_id
            @current_user=User.where(:id=>doorkeeper_token.resource_owner_id).first
          end    
        end
        @current_user
      end
  end
end
