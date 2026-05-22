# frozen_string_literal: true

module Api
  module V1
    class MyaccountController < ApiController
      before_action :set_params, only: :update

      def profile
        render json: { data: current_user, mfa_status: current_user.otp_module_enabled? }, status: :ok
      end

      def update
        if current_user.update(set_params)
          UserMailer.update_password(current_user).deliver_now
          render json: { message: 'Senha atualizado, realize o login novamente!' }, status: :ok
        else
          render json: { error: current_user.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      def open_qrcode_mfa
        temp_blob = QrcodeCreateService.new(@resource, request).build
         
        if temp_blob.present? 
          render json: { qrcode: temp_blob.url }, status: :ok
        else
          render json: { qrcode: 'Erro ao processar o QRCODE' }, status: :ok
        end
      end

      private

      def set_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
