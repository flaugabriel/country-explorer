# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:search_histories).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'creation' do
    it 'is valid with correct params' do
      expect(user).to be_valid
    end

    it 'is invalid with a weak password' do
      expect(build(:user, password: 'weak', password_confirmation: 'weak')).not_to be_valid
    end
  end

  describe '#generate_password_token!' do
    it 'sets reset_password_token and reset_password_sent_at' do
      user.generate_password_token!
      expect(user.reset_password_token).not_to be_nil
      expect(user.reset_password_sent_at).not_to be_nil
    end
  end

  describe '#password_token_valid?' do
    it 'returns true when token is less than 4 hours old' do
      user.generate_password_token!
      expect(user.password_token_valid?).to be true
    end

    it 'returns false when token is older than 4 hours' do
      user.generate_password_token!
      travel 5.hours
      expect(user.password_token_valid?).to be false
    end
  end

  describe '#reset_password!' do
    before { user.generate_password_token! }

    it 'clears the token and updates the password' do
      user.reset_password!('GN&03i4686#Z')
      expect(user.reload.reset_password_token).to be_nil
    end

    it 'returns true on success' do
      result = user.reset_password!('GN&03i4686#Z')
      expect(result).to be true
    end
  end

  describe 'after_update callback: check_if_user_is_locker' do
    it 'sends a notification email when failed_attempts reaches maximum' do
      ActionMailer::Base.deliveries.clear
      user.update_columns(failed_attempts: User.maximum_attempts - 1)
      user.update!(failed_attempts: User.maximum_attempts)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'does not send an email when failed_attempts is below maximum' do
      ActionMailer::Base.deliveries.clear
      user.update!(failed_attempts: 0)
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
