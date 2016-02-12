module Api
  class BaseController < ApplicationController
#    before_action :authenticate_user!, except: [:index, :show ]
#    before_action :user_signed_in?, except: [:index, :show ]
    before_action :doorkeeper_authorize! , except: [:index, :show ]
    protect_from_forgery with: :null_session
    respond_to :json
  end
end
