class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = current_user
  end

  def update
    if current_user.update(profile_params)
      redirect_to edit_mypage_account_path, success: '変更しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :email, :profile_image)
  end
end
