class UsersController < ApplicationController

  before_filter :set_user, only: [:edit, :update, :reset_password, :destroy]

  def privileges
    [{generic:[:users_management]},
    {action:"my_data", validations:[]},
    {action:"update_my_data", validations:[]}]
  end
  def index
    @users = User.all
  end

  def new
    @privileges = { modules: Role.modules, reports: Role.reports, actions: Role.actions }
    @user = User.new
  end

  def create
    @privileges = { modules: Role.modules, reports: Role.reports, actions: Role.actions }
    @user = User.new params[:user]
    @user.password = params[:user][:id_number]
    @user.password_confirmation = params[:user][:id_number]
    @user.kitchens << Kitchen.first
    if @user.save
      redirect_to users_path
    else
      render 'new'
    end  
  end

  def edit
    @privileges = {modules: Role.modules, reports: Role.reports, actions: Role.actions}
  end

  def update
    if @user.update_attributes params[:user]
      @user.roles.delete_all
      @user.kitchens.delete_all
      params[:privileges_attributes].each do |d|
        Privilege.create(user_id: @user.id, role_id: d[:role_id])
      end
      params[:kitchens_attributes].each do |k|
        UserKitchen.create(user_id: @user.id, kitchen_id: k[:kitchen_id])
      end if params[:kitchens_attributes]
      redirect_to users_path
    else
      @privileges = {modules: Role.modules, reports: Role.reports, actions: Role.actions}
      render 'edit'
    end    
  end

  def reset_password
    @response = @user.reset_password
  end
    
  def destroy
    @user.destroy
    redirect_to users_path
  end

  def my_data
    @user = current_user
  end

  def update_my_data
    if params[:user][:password].to_s.empty?
      current_user.name =  params[:user][:name]
      current_user.email =  params[:user][:email]
      current_user.id_number =  params[:user][:id_number]
      current_user.save
      redirect_to root_path
    else
      if params[:user][:password] == params[:user][:password_confirmation]
        current_user.update_attributes params[:user]
        current_user.password = params[:user][:password]
        current_user.password_confirmation = params[:user][:password]
        current_user.save
        redirect_to root_path
      else
        redirect_to my_data_path
      end
    end
  end


  protected

  def set_user
    @user = User.find params[:id]
  end

end
