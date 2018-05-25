module LoginMacros
  def login(user)
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_on 'Sign In'
    visit root_path
  end
end
