class UnlockController < ApplicationController
  # Sobrescreve o método padrão para lidar com o desbloqueio de conta
  def show
    user = User.find_by(email: params[:unlock_token])
    user.unlock_access!

    if user.errors.empty?
      render json: {status: 'ok'}, status: :ok
    else
      # :nocov:
      render json: {erorrs: user.errors, status: :unprocessable_entity }
      # :nocov:
    end
  end
end
 