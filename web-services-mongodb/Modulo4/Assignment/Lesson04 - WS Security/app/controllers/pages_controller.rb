class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show ]
  before_action :user_signed_in?, except: [:index, :show ]

  def index
  end
end
