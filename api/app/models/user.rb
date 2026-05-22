# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :registerable, :timeoutable, :lockable,
  :rememberable, :validatable, :trackable, :two_factor_authenticatable
  include DeviseTokenAuth::Concerns::User
  
  has_many :search_histories, dependent: :destroy

  has_one_time_password
  enum otp_module: { disabled: 0, enabled: 1}, _prefix: true
  attr_accessor :otp_code_token

  validates_presence_of :email, on: :create, message: 'não pode fica em branco'
  validates_uniqueness_of :email, on: :create, message: 'deve ser unico'

  after_update :check_if_user_is_locker

  validates :password, format: {
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>]).{12,32}\z/,
    message: "deve ter entre 12 e 32 caracteres, pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial"
  }, on: :create

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end
   
  def password_token_valid?
   (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
   
  def reset_password!(password)
   self.reset_password_token = nil
   self.password = password
   self.password_confirmation = password
   save!
  end
   
  private

  def check_if_user_is_locker
    if self.failed_attempts >= User.maximum_attempts
      UserMailer.login_attempt_notification(self).deliver_now
    end
  end
  
  def generate_token
   SecureRandom.hex(10)
  end
end
