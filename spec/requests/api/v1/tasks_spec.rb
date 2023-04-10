# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user_ar) { create(:user) }
  let(:user_repository) { User::Infrastructure::ActiveRecordUserRepository }
  let(:token) { Auth::UseCases::CreateToken.new(user_repository:).call(user_id: user_ar.id) }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  describe 'POST /api/v1/tasks' do
    subject { post '/api/v1/tasks', params:, headers: }

    context 'when params are valid' do
      let(:params) { { task: { name: 'Task 1', due_at: 2.days.from_now.iso8601 } } }

      it 'is successful' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'creates a new task' do
        expect { subject }.to change(Task::Infrastructure::ActiveRecordTaskRepository, :count).by(1)
      end

      it 'returns created task id' do
        subject
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:id]).to eq(Task::Infrastructure::ActiveRecordTaskRepository.last.id)
      end
    end

    context 'when params are invalid' do
      let(:params) { { task: { name: '', description: 'd' * 2501, due_at: 1.day.ago.to_date.to_s } } }

      it 'is not successful' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation messages' do
        subject
        body = JSON.parse(response.body, symbolize_names: true).fetch(:error)
        expect(body).to include(
          {
            type: 'ValidationError',
            message: 'Validation error',
            details: ['Name cannot be empty', 'Description too long', 'Due at cannot be in the past']
          }
        )
      end

      context 'when name is too long' do
        let(:params) { { task: { name: 'n' * 251, due_at: 3.days.from_now } } }

        it 'returns validation messages' do
          subject
          body = JSON.parse(response.body, symbolize_names: true).fetch(:error)
          expect(body).to include(
            {
              type: 'ValidationError',
              message: 'Validation error',
              details: include(
                'Name too long'
              )
            }
          )
        end
      end
    end
  end

  describe 'PUT /api/v1/tasks/:id' do
    let(:task) { create(:task) }

    subject(:put_update_task) { put(api_v1_task_path(task.id), params:, headers:) }

    context 'when params are valid' do
      let(:params) { { task: { name: 'new name', description: 'new description', due_at: 3.days.from_now } } }
      let(:mailer) { double(deliver_later: nil) }

      it 'update task' do
        expect { put_update_task }
          .to(change { task.reload.name }.to('new name')
          .and(change { task.reload.description }.to('new description'))
          .and(change { task.reload.due_at }))
      end

      it 'returns updated task id' do
        put_update_task

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eq({ id: task.id })
      end

      it 'sends email' do
        allow(TaskMailer).to receive(:task_updated).with(task.id, ['dev@mail.com']).and_return(mailer)

        put_update_task

        expect(mailer).to have_received(:deliver_later)
      end
    end
  end

  describe 'POST /api/v1/tasks/:id/mark_as_completed' do
    let(:task) { create(:task) }

    subject(:post_mark_as_completed) { post mark_as_completed_api_v1_task_path(task.id), headers: }
    it 'changes completed to true' do
      expect { post_mark_as_completed }.to change {
                                             task.reload.completed
                                           }.from(false).to(true)
    end

    it 'returns no content' do
      post_mark_as_completed

      expect(response).to have_http_status :no_content
    end
  end

  describe 'POST /api/v1/tasks/:id/mark_as_pending' do
    let(:task) { create(:task, completed: true) }

    subject(:post_mark_as_pending) { post mark_as_pending_api_v1_task_path(task.id), headers: }

    it 'changes completed to false' do
      expect { post_mark_as_pending }.to change {
                                           task.reload.completed
                                         }.from(true).to(false)
    end

    it 'returns no content' do
      post_mark_as_pending

      expect(response).to have_http_status :no_content
    end
  end
end
