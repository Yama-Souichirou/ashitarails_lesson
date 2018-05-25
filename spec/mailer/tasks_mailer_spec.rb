require 'rails_helper'

RSpec.describe TasksMailer, type: :mailer do

  describe 'send_responsible_task' do
    let(:task) { FactoryGirl.build(:task, :with_user, :with_responsible) }

    it 'sends an email' do
      expect {
        TasksMailer.send_responsible_task(task).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
