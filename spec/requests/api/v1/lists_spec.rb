require 'swagger_helper'

RSpec.describe 'api/v1/lists', type: :request do
  let!(:created_lists) { create_list(:list, 2) }
  let!(:created_list) { created_lists[0] }
  let(:id) { created_list.id }
  let(:built_list) { build(:list) }
  let(:request_body) { built_list.slice(:name) }

  path '/api/v1/lists' do
    get('list lists') do
      tags 'Lists'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: { '$ref' => '#/components/schemas/lists_show' }

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(created_lists.length)
          response_body.length.times do |index|
            expect_list_data(response_body[index], created_lists[index])
          end
        end
      end
    end

    post('create list') do
      tags 'Lists'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :request_body, in: :body, schema: { '$ref' => '#/components/schemas/lists_create' }

      response(201, 'successful') do
        schema '$ref' => '#/components/schemas/lists_show'

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          saved_list = List.find(response_body[:id])
          expect(saved_list.name).to eq(built_list.name)
          expect_list_data(response_body, saved_list)
        end
      end
    end
  end

  path '/api/v1/lists/{id}' do
    # You'll want to customize the parameter types...
    parameter name: :id, in: :path, type: :string, description: 'id'

    get('show list') do
      tags 'Lists'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lists_show'

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect_list_data(response_body, created_list)
        end
      end
    end

    patch('update list') do
      tags 'Lists'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :request_body, in: :body, schema: { '$ref' => '#/components/schemas/lists_update' }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lists_show'

        run_test! do |response|
          saved_list = List.find(id)
          expect(saved_list.name).to eq(built_list.name)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect_list_data(response_body, saved_list)
        end
      end
    end

    delete('delete list') do
      tags 'Lists'

      response(204, 'successful') do
        run_test!
      end
    end
  end

  def expect_list_data(data, object)
    expect(data[:name]).to eq(object.name)
    expect(data[:created_at]).to eq(object.created_at.as_json.to_s)
    expect(data[:updated_at]).to eq(object.updated_at.as_json.to_s)
  end
end
