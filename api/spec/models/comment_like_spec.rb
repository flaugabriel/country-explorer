# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }
  let(:comment) { Comment.create!(country_code: 'BRA', user_email: 'a@a.com', content: 'Legal!') }

  it 'is valid with valid attributes' do
    like = described_class.new(comment: comment, user: user, like: true)
    expect(like).to be_valid
  end

  it 'is invalid without like value' do
    like = described_class.new(comment: comment, user: user)
    expect(like).not_to be_valid
  end

  it 'is invalid with duplicate user per comment' do
    described_class.create!(comment: comment, user: user, like: true)
    dup = described_class.new(comment: comment, user: user, like: false)
    expect(dup).not_to be_valid
  end
end
