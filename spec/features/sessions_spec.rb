require 'rails_helper'

RSpec.feature 'Session new', type: :feature, js: true do
  
  describe 'user' do
    
    describe 'login' do
      before do
        FactoryGirl.create(:user)
        visit new_session_path
      end
  
      it 'should have content "ログインしました" ' do
        fill_in 'メールアドレス', with: 's.yama@ashita-team.com'
        fill_in 'パスワード', with: 'password'
        click_on 'Sign In'
    
        expect(page).to have_content 'ログインしました'
      end

      describe 'admin page' do
        before do
          fill_in 'メールアドレス', with: 's.yama@ashita-team.com'
          fill_in 'パスワード', with: 'password'
          click_on 'Sign In'
        end
        
        context 'visit admin_users_path' do
          before { visit admin_users_path }
          it 'redirect root_path' do
            expect(page).to have_current_path(root_path)
            expect(page).to have_content('このアカウントではページに入れません')
          end
        end

        context 'visit admin_labels_path' do
          before { visit admin_labels_path }
          it 'redirect root_path' do
            expect(page).to have_current_path(root_path)
            expect(page).to have_content('このアカウントではページに入れません')
          end
        end

        context 'visit admin_tasks_path' do
          before { visit admin_tasks_path }
          it 'redirect root_path' do
            expect(page).to have_current_path(root_path)
            expect(page).to have_content('このアカウントではページに入れません')
          end
        end

        context 'visit new_admin_registration_path' do
          before { visit new_admin_registration_path }
          it 'redirect root_path' do
            expect(page).to have_current_path(root_path)
            expect(page).to have_content('このアカウントではページに入れません')
          end
        end
      end
    end

    describe 'un login', js: true do
      let(:user) { FactoryGirl.create(:user) }
      
      context 'visit tasks_path' do
        before { visit tasks_path }
        it 'redirect sessions new' do
          expect(page).to have_current_path(new_session_path)
        end
      end
  
      context 'visit user_path' do
        before { visit user_path(user) }
        it 'redirect sessions new' do
          expect(page).to have_current_path(new_session_path)
        end
      end
  
      context 'visit root_path' do
        before { visit root_path }
        it 'redirect sessions new' do
          expect(page).to have_current_path(new_session_path)
        end
      end
    end
  end
  
  describe 'admin' do
    before do
      FactoryGirl.create(:admin)
      visit new_session_path
      fill_in 'メールアドレス', with: 's.yama@admin.com'
      fill_in 'パスワード', with: 'password'
      click_on 'Sign In'
    end
    
    context 'visit admin_users_path' do
      before { visit admin_users_path }
      it 'current page admin_users_path' do
        expect(page).to have_current_path(admin_users_path)
      end
    end
  end
end
