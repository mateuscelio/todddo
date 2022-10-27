# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /api/v1/tasks' do
    subject { post '/api/v1/tasks', params: }

    context 'when params are valid' do
      let(:params) { { name: 'Task 1' } }

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
      let(:params) { { name: '', description: 'd' * 2501, due_at: 1.day.ago.to_date.to_s } }

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
        let(:params) { { name: 'n' * 251 } }

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
end
