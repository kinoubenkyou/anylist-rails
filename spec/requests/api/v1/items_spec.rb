require 'swagger_helper'

RSpec.describe 'api/v1/items', type: :request do
  let!(:created_list) { create(:list) }
  let!(:list_id) { created_list.id }
  let!(:created_items) { create_list(:item, 2, list_id: list_id) }
  let!(:created_item) { created_items[0] }
  let(:id) { created_item.id }
  let(:built_item) { build(:item, list_id: list_id) }
  let(:request_body) { built_item.slice(:value, :description) }

  path '/api/v1/lists/{list_id}/items' do
    # You'll want to customize the parameter types...
    parameter name: 'list_id', in: :path, type: :string, description: 'list_id'

    get('list items') do
      tags 'Items'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: { '$ref' => '#/components/schemas/items_show' }

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(created_items.length)
          response_body.length.times do |index|
            expect_item_data(response_body[index], created_items[index])
          end
        end
      end
    end

    post('create item') do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :request_body, in: :body, schema: { '$ref' => '#/components/schemas/items_create' }

      response(201, 'successful') do
        schema '$ref' => '#/components/schemas/items_show'

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          saved_item = Item.find(response_body[:id])
          expect(saved_item.value).to eq(built_item.value)
          expect(saved_item.description).to eq(built_item.description)
          expect_item_data(response_body, saved_item)
        end
      end
    end
  end

  path '/api/v1/lists/{list_id}/items/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'list_id', in: :path, type: :string, description: 'list_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show item') do
      tags 'Items'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/items_show'

        run_test! do |response|
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect_item_data(response_body, created_item)
        end
      end
    end

    patch('update item') do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :request_body, in: :body, schema: { '$ref' => '#/components/schemas/items_update' }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/items_show'

        run_test! do |response|
          saved_item = Item.find(id)
          expect(saved_item.value).to eq(built_item.value)
          expect(saved_item.description).to eq(built_item.description)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect_item_data(response_body, saved_item)
        end
      end
    end

    delete('delete item') do
      tags 'Items'

      response(204, 'successful') do
        run_test!
      end
    end
  end

  def expect_item_data(data, object)
    expect(data[:value]).to eq(object.value)
    expect(data[:description]).to eq(object.description)
    expect(data[:created_at]).to eq(object.created_at.as_json.to_s)
    expect(data[:updated_at]).to eq(object.updated_at.as_json.to_s)
  end
end
