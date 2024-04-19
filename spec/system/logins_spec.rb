require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  describe 'ログイン機能' do
    let(:user) { create(:user) }

    context 'ログインフォームに誤った情報が入力されている' do
      it 'ログインできずエラーメッセージが表示される' do
        visit '/login'
        fill_in 'メールアドレス', with: 'wrong@example.com'
        fill_in 'パスワード', with: '12345678'
        click_on 'ログイン'
        expect(page).to have_content 'ログインに失敗しました'
      end
    end

    context 'ログインフォームに正しい情報が入力されている' do
      it 'ログインし成功メッセージが表示される' do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        click_on 'ログイン'
        expect(page).to have_content 'ログインしました'
      end
    end
  end
end
