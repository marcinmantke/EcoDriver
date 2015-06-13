require 'rails_helper'

feature 'the signin process', type: :feature do
  before :each do
    FactoryGirl.create(:user)
  end

  it 'show modal', js: true do
    visit '/login'
    expect(page).to have_no_css '.modal-content'
    click_button 'open_sign_in'
    expect(page).to have_css '.modal-content'
  end

  it 'signs me in', js: true, js_errors: false do
    visit '/login'
    click_button 'open_sign_in'
    fill_in 'user_login', with: 'Test_user'
    fill_in 'user_password', with: '12345678'
    click_button 'sign_in'
    expect(page).to have_css '.sidebar'
  end
end
