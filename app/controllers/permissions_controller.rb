class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]
  before_action :set_document

  # FIXME: before_create/update should verify
  #   if there's already a permission on this doc for this user

  # GET documents/1/permissions
  def index
    @permissions = Permission.where(document: @document)
  end

  # GET documents/1/permissions/new
  def new
    @permission = Permission.new
  end

  # POST documents/1/permissions
  def create
    # FIXME: If cannot find, should create User and sent invitation
    #   e.g FindOrInviteUserService
    user = User.find_by(email: secure_params[:user][:email])

    @permission = Permission.new(
      document: @document,
      user: user,
      role: secure_params[:role]
    )

    if @permission.save
      redirect_to document_permissions_path
    else
      redirect_to document_permissions_path, notice: 'Something went wrong.'
    end
  end

  # GET documents/1/permissions/1/edit
  def edit
    @document
  end

  # PATCH/PUT documents/1/permissions/1
  def update
    # FIXME: If cannot find, should create User and sent invitation
    #   e.g FindOrInviteUserService
    user = User.find_by(email: secure_params[:user][:email])

    if @permission.update(user: user, role: secure_params[:role])
      redirect_to document_permissions_path
    else
      redirect_to document_permissions_path, notice: 'Something went wrong.'
    end
  end

  # DELETE documents/1/permissions/1
  def destroy
    @permission.destroy!

    redirect_to document_permissions_path
  end

  private

  def secure_params
    params.require(:permission).permit(:role, user: [:email])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.includes(:user).find(params[:id])
  end

  def set_document
    @document = Document.find(params[:document_id])
  end
end
