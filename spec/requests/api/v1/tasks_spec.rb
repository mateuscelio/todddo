# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /api/v1/tasks' do
    subject { post '/api/v1/tasks', params: }

    context 'when params are valid' do
      let(:params) { { task: { name: 'Task 1' } } }

      it 'is successful' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'creates a new task' do
        expect { subject }.to change(Task, :count).by(1)
      end

      it 'returns created task id' do
        subject
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:id]).to eq(Task.last.id)
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
            details: include(
              "Name can't be blank",
              'Description is too long (maximum is 2500 characters)',
              'Due at cannot be in the past'
            )
          }
        )
      end

      context 'when name is too long' do
        let(:params) { { task: { name: 'n' * 251 } } }

        it 'returns validation messages' do
          subject
          body = JSON.parse(response.body, symbolize_names: true).fetch(:error)
          expect(body).to include(
            {
              type: 'ValidationError',
              message: 'Validation error',
              details: include(
                'Name is too long (maximum is 250 characters)'
              )
            }
          )
        end
      end
    end
  end

  describe 'PUT /api/v1/tasks/:id' do
    let(:task) { create(:task) }

    context 'when params are valid' do
      let(:params) { { task: { name: 'new name', description: 'new description', due_at: 3.days.from_now } } }
      let(:mailer) { double(deliver_later: nil) }

      it 'update task' do
        expect { put(api_v1_task_path(task.id), params:) }
          .to(change { task.reload.name }.to('new name')
          .and(change { task.reload.description }.to('new description'))
          .and(change { task.reload.due_at }))
      end

      it 'returns updated task id' do
        put(api_v1_task_path(task.id), params:)

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eq({ id: task.id })
      end

      it 'sends email' do
        allow(TaskMailer).to receive(:task_updated).with(task.id, ['dev@mail.com']).and_return(mailer)

        put(api_v1_task_path(task.id), params:)

        expect(mailer).to have_received(:deliver_later)
      end
    end
  end

  describe 'POST /api/v1/tasks/:id/mark_as_completed' do
    let(:task) { create(:task) }

    it 'changes completed to true' do
      expect { post mark_as_completed_api_v1_task_path(task.id) }.to change {
                                                                       task.reload.completed
                                                                     }.from(false).to(true)
    end

    it 'returns no content' do
      post mark_as_pending_api_v1_task_path(task.id)

      expect(response).to have_http_status :no_content
    end
  end

  describe 'POST /api/v1/tasks/:id/mark_as_pending' do
    let(:task) { create(:task, completed: true) }

    it 'changes completed to false' do
      expect { post mark_as_pending_api_v1_task_path(task.id) }.to change {
                                                                     task.reload.completed
                                                                   }.from(true).to(false)
    end

    it 'returns no content' do
      post mark_as_pending_api_v1_task_path(task.id)

      expect(response).to have_http_status :no_content
    end
  end
end
