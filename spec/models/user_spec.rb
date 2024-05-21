# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#like' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    it 'いいねできること' do
      expect { user.like(post) }.to change { Like.count }.by(1)
    end
  end

  describe '#unlike' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    before do
      user.like(post)
    end
    it 'いいねが解除できること' do
      expect { user.unlike(post) }.to change { Like.count }.by(-1)
    end
  end

  describe '#like?' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:not_liked_post) { create(:post) }
    before do
      user.like(post)
    end
    it 'いいねしてるかどうかを判定できること' do
      expect(user.like?(post)).to be true
      expect(user.like?(not_liked_post)).to be false
    end
  end

  describe '#follow' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    it 'フォローできてRelationshipモデルのレコードが1件増える' do
      expect { user.follow(followed_user) }.to change { Relationship.count }.by(1)
    end
  end

  describe '#unfollow' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    before do
      user.follow(followed_user)
    end
    it 'フォロー解除ができてRelationshipモデルのレコードが1件減る' do
      expect { user.unfollow(followed_user) }.to change { Relationship.count }.by(-1)
    end
  end

  describe '#follow?' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:not_followed_user) { create(:user) }
    before do
      user.follow(followed_user)
    end
    context 'フォローしている場合' do
      it 'trueを返す' do
        expect(user.follow?(followed_user)).to be true
      end
    end

    context 'フォローしていない場合' do
      it 'falseを返す' do
        expect(user.follow?(not_followed_user)).to be false
      end
    end
  end

  # describe '#recent' do
  #   4.times do |count|
  #     let!("user_#{count}".to_sym) { create(:user) }
  #   end
  #   it 'user_1~5までがrecentに含まれている' do
  #     expect(User.recent(3)).to eq [ user_3, user_2, user_1 ]
  #   end
  # end

  describe '#recent' do
    let(:base_datetime) { Time.current }
    let!(:user_a) { create(:user, created_at: base_datetime) }
    let!(:user_b) { create(:user, created_at: base_datetime.ago(1.day)) }
    let!(:user_c) { create(:user, created_at: base_datetime.ago(2.day)) }
    let!(:user_d) { create(:user, created_at: base_datetime.ago(3.day)) }
    it '新しくアカウントが作られた順にユーザーを取得できる' do
      expect(User.recent(3)).to eq [user_a, user_b, user_c]
    end
  end

  describe '#feed' do
    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }
    let!(:user_c) { create(:user) }
    let!(:post_by_user_a) { create(:post, user: user_a) }
    let!(:post_by_user_b) { create(:post, user: user_b) }
    let!(:post_by_user_c) { create(:post, user: user_c) }
    before do
      user_a.follow(user_b)
    end
    subject { user_a.feed }
    # 自分の投稿と自分がフォローしている人の投稿のみが返される
    it { is_expected.to include post_by_user_a }
    it { is_expected.to include post_by_user_b }
    it { is_expected.not_to include post_by_user_c }
  end

  describe '#accept_notification?' do
    let!(:user) { create(:user) }
    describe ':on_commented' do
      before do
        notification_timing = NotificationTiming.find_by!(timing_type: :on_commented)
        user.notification_timings << notification_timing
      end

      it 'コメント時の通知のみ許可されていること' do
        expect(user.accept_notification?(:on_commented)).to eq true
        expect(user.accept_notification?(:on_liked)).to eq false
        expect(user.accept_notification?(:on_followed)).to eq false
      end
    end

    describe ':on_liked' do
      before do
        notification_timing = NotificationTiming.find_by!(timing_type: :on_liked)
        user.notification_timings << notification_timing
      end

      it 'いいね時の通知のみ許可されていること' do
        expect(user.accept_notification?(:on_commented)).to eq false
        expect(user.accept_notification?(:on_liked)).to eq true
        expect(user.accept_notification?(:on_followed)).to eq false
      end
    end

    describe ':on_followed' do
      before do
        notification_timing = NotificationTiming.find_by!(timing_type: :on_followed)
        user.notification_timings << notification_timing
      end

      it 'フォロー時の通知のみ許可されていること' do
        expect(user.accept_notification?(:on_commented)).to eq false
        expect(user.accept_notification?(:on_liked)).to eq false
        expect(user.accept_notification?(:on_followed)).to eq true
      end
    end
  end

end
