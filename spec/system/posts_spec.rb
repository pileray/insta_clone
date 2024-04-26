require 'rails_helper'

RSpec.describe "投稿のCRUD", type: :system do
  let(:user) { create(:user) }
  before do
    login_as(user)
  end

  describe '投稿' do
    context '正しい入力の場合' do
      it '投稿が成功しメッセージが表示される' do
        within '#header' do
          click_on '投稿'
        end
        fill_in '本文', with: 'テキストです'
        attach_file '画像', 'spec/fixtures/dummy.jpg'
        click_on '登録する'
        expect(page).to have_content '投稿しました'
      end
    end
  end

  describe '編集' do
    let(:post) { create(:post, user: user) }
    it '編集が成功しメッセージが表示される' do
      visit "/posts/#{post.id}"
      find('#postDropdownMenuLink').click
      click_on '編集'
      fill_in '本文', with: 'てきすとです'
      click_on '更新する'
      expect(page).to have_content '投稿を更新しました'
      expect(page).to have_content 'てきすとです'
    end
  end

  describe '削除' do
    let(:post) { create(:post, user: user) }
    it '削除ができること' do
      visit "/posts/#{post.id}"
      find('#postDropdownMenuLink').click
      accept_confirm { click_on '削除' }
      expect(page).to have_content '投稿を削除しました'
      expect(page).not_to have_content post.body
    end
  end

  describe 'ページネーション' do
    let!(:post){ create(:post, created_at: Time.current.yesterday) }
    before do
      create_list(:post, 15)
    end
    it '16件目以降が作成された場合、ページネーションが追加される' do
      visit "/posts"
      expect(page).not_to have_selector "#post_#{post.id}"
    end
  end

end
