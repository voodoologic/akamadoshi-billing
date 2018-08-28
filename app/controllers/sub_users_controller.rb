class SubUsersController < ApplicationController
  include SubUsersHelper
  load_and_authorize_resource :user, :only => [:index, :show, :create, :destroy, :update, :new, :edit, :destroy_bulk]

  helper_method :sort_column, :sort_direction

  def index
    @sub_users = User.filter(params, @per_page)
    @user_activities = User.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @sub_user = User.new()
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @sub_user = User.new({user_name: params[:user_name], email: params[:email],
                         password: params[:password],
                         password_confirmation: params[:password_confirmation]
                        })

    @sub_user.account_id = current_user.account_id if User.method_defined?(:account_id)
    @sub_user.role_ids = params[:role_ids]
    # skip email confirmation for login
    @sub_user.skip_confirmation!
    respond_to do |format|
      if @sub_user.already_exists?(params[:email])
        redirect_to(sub_users_url, alert: t('views.users.duplicate_email'))
        return
      elsif @sub_user.save
        # assign current user's company to newly created user
        @sub_user.update(current_company: get_company_id)
        current_user.accounts.first.users << @sub_user
        begin
          UserMailer.new_user_account(current_user, @sub_user).deliver if params[:notify_user].to_i == 1
        rescue => e
          puts  e
        end
        if params[:setting_form] == '1'
          @users = User.unscoped
          format.js
        else
          redirect_to(sub_users_url, notice: t('views.users.saved_msg'))
        end
        return
      else
        format.js {}
        format.html { render action: 'new', alert: t('views.users.unable_to_save') }
      end
    end
  end

  def edit
    @sub_user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @sub_user = User.find(params[:user_id])
    options = {user_name: params[:user_name], email: params[:email],
               password: params[:password], password_confirmation: params[:password],
               avatar: params[:avatar]}

    # don't update password if not provided
    if params[:password].blank?
      options.delete(:password)
      options.delete(:password_confirmation)
    end
    message = if @sub_user.update_attributes(options)
                @successfully_updated = true
                @sub_user.role_ids = params[:role_ids] if params[:role_ids].present?
                {notice: t('views.users.updated_msg')}
              else
                {alert: t('views.users.unable_to_save')}
              end

    respond_to do |format|
      format.html {
        if password_has_changed?(params[:user_id], params[:password]) && @successfully_updated.eql?(true)
          redirect_to(new_user_session_path, message)
        elsif params[:setting_form] == '1'
          redirect_to(settings_path, message)
        else
          redirect_to(sub_users_path, message)
        end
      }
    end
  end

  def destroy
    sub_user = User.find_by_id(params[:id]).destroy

    respond_to do |format|
      format.js
      format.json { render_json(sub_user) }
    end
  end

  def destroy_bulk
    sub_user = User.where(id: params[:user_ids]).destroy_all
    @users = User.all
    render json: {notice: t('views.users.bulk_delete'),
                  html: render_to_string(action: :settings_listing, layout: false)}
  end

  def user_settings
  end

  def settings_listing
    @users = User.all
    render layout: false
  end

  private
  def sort_column
    params[:sort] ||= 'user_name'
    User.column_names.include?(params[:sort]) ? params[:sort] : 'user_name'
  end

  def sort_direction
    params[:direction] ||= 'desc'
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
