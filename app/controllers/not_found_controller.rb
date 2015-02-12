class NotFoundController < ApplicationController
  respond_to :html
  def show
    respond_to do |format|
      format.html { render status: 404 }
      format.all  { redirect_to not_found_path, format: :html }
    end
  end
end
