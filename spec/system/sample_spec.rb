require 'rails_helper'

RSpec.describe 'sample', type: :system do
  describe "rootにアクセスすると「テストです」が表示される" do
    it 'ページが開ける' do
      visit '/'
      expect(page).to have_content 'テストです'
    end
  end
end
