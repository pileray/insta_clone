require 'rails_helper'

RSpec.describe "アカウント", type: :system do
  let!(:user){ create(:user) }
  before do
    login_as(user)
  end
  describe 'アカウント編集機能' do
    it '編集ページでプロフィール編集ができる' do
      find('#navbarDropdownMenuAvatar').click
      click_on 'プロフィール'
      expect(current_path).to eq '/mypage/account/edit'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'ユーザー名', with: 'テスト'
      attach_file('user[profile_image]', 'spec/fixtures/dummy.jpg')
      click_on '更新する'
      sleep 1
      user.reload
      expect(user.username).to eq 'テスト'
      expect(user.email).to eq 'test@example.com'
      expect(user.profile_image.attached?).to eq true
    end
  end
end
