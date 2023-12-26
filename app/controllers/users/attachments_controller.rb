# frozen_string_literal: true

class Users::AttachmentsController < ApplicationController
  def destroy
    @user = User.find(params[:user_id])
    @user.image.purge
    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: t('controllers.common.notice_update', name: User.model_name.human) }
      format.json { render :show, status: :ok, location: @user }
    end
  end
end
