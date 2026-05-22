# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }

  it 'is valid with all attributes' do
    comment = described_class.new(country_code: '076', user: user, user_email: user.email, content: 'Ótimo país!')
    expect(comment).to be_valid
  end

  it 'is invalid without country_code' do
    comment = described_class.new(user: user, user_email: user.email, content: 'Ótimo país!')
    expect(comment).not_to be_valid
  end

  it 'is invalid without user_email' do
    comment = described_class.new(country_code: '076', user: user, content: 'Ótimo país!')
    expect(comment).not_to be_valid
  end

  it 'is invalid without content' do
    comment = described_class.new(country_code: '076', user: user, user_email: user.email)
    expect(comment).not_to be_valid
  end

  it 'is invalid with content too short' do
    comment = described_class.new(country_code: '076', user: user, user_email: user.email, content: 'a')
    expect(comment).not_to be_valid
  end

  it 'can be created without user (anonymous)' do
    comment = described_class.new(country_code: '076', user_email: 'anon@email.com', content: 'Legal!')
    expect(comment).to be_valid
  end

  it 'scopes by country' do
    c1 = described_class.create!(country_code: '076', user_email: 'a@a.com', content: 'AAA')
    c2 = described_class.create!(country_code: '156', user_email: 'b@b.com', content: 'BBB')
    expect(described_class.for_country('076')).to include(c1)
    expect(described_class.for_country('076')).not_to include(c2)
  end
end
