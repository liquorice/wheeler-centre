module Heracles
  module Admin
    class UsersController < ApplicationController
      self.policy_class = UserPolicy

      expose(:users_scope) { policy_scope(Heracles::User) }
      expose(:users) { users_scope.order(:email) }
      expose(:user, ancestor: :users_scope, model: "heracles/user")

      expose(:sites) { Heracles.site_administration_class.sites_administerable_by(heracles_admin_current_user) }

      respond_to :html

      before_filter :remove_empty_password_params

      def index
        authorize Heracles::User
      end

      def new
        authorize user
      end

      def create
        authorize user

        user.save
        respond_with user, location: users_path
      end

      def edit
        authorize user
      end

      def update
        authorize user

        user.save
        respond_with user, location: users_path
      end

      def destroy
        authorize user

        user.destroy
        respond_with user, location: users_path
      end

      protected

      def remove_empty_password_params
        if params[:heracles_user] && params[:heracles_user][:password].blank?
          params[:heracles_user].delete :password
          params[:heracles_user].delete :password_confirmation
        end
      end
    end
  end
end
