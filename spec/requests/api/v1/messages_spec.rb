describe 'Messages API', type: :request do
  describe 'GET /api/v1/messages' do
    specify 'get messages list' do
      create(:message, first_name: 'John', last_name: 'Doe', email: 'john@example.com', amount: 15)

      get '/api/v1/messages'

      expect(json_response).to contain_exactly(
        { email: 'john@example.com', first_name: 'John', last_name: 'Doe', amount: 15 }
      )
    end

    specify 'search by last name' do
      create(:message, first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 5)
      create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
      create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)

      get '/api/v1/messages', params: { search_key: 'last_name', search_value: 'watson' }

      expect(json_response).to contain_exactly(
        { email: 'watson@e.com', first_name: 'John', last_name: 'Watson', amount: 5 }
      )
    end

    specify 'search by email' do
      create(:message, first_name: 'Lucie', last_name: 'Doe', email: 'lucie.doe@g.com', amount: 5)
      create(:message, first_name: 'David', last_name: 'Johnson', email: 'jonson.test@mail.com', amount: 5)

      get '/api/v1/messages', params: { search_key: 'email', search_value: 'lucie' }

      expect(json_response).to contain_exactly(
        { email: 'lucie.doe@g.com', first_name: 'Lucie', last_name: 'Doe', amount: 5 }
      )
    end

    context 'sort and search combined' do
      before do
        create(:message, first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5)
        create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
        create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)
        create(:message, first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 15)
      end

      specify 'sort by first_name' do
        get '/api/v1/messages', params: { sort_key: 'first_name', sort_direction: 'desc' }

        expect(json_response).to contain_exactly(
          { email: 'scott@example.com', first_name: 'Scott', last_name: 'Asd', amount: 5 },
          { email: 'watson@e.com', first_name: 'John', last_name: 'Watson', amount: 5 },
          { email: 'e.doe@g.com', first_name: 'Emily', last_name: 'Doe', amount: 10 },
          { email: 'doe@g.com', first_name: 'John', last_name: 'Doe', amount: 15 }
        )
      end

      specify 'sort by amount' do
        get '/api/v1/messages', params: { sort_key: 'amount', sort_direction: 'desc' }

        expect(json_response).to contain_exactly(
          { email: 'doe@g.com', first_name: 'John', last_name: 'Doe', amount: 15 },
          { email: 'e.doe@g.com', first_name: 'Emily', last_name: 'Doe', amount: 10 },
          { email: 'scott@example.com', first_name: 'Scott', last_name: 'Asd', amount: 5 },
          { email: 'watson@e.com', first_name: 'John', last_name: 'Watson', amount: 5 }
        )
      end

      specify 'sort by amount and search by last name' do
        get '/api/v1/messages', params: {
          search_key: 'last_name',
          search_value: 'doe',
          sort_key: 'amount',
          sort_direction: 'desc'
        }

        expect(json_response).to contain_exactly(
          { email: 'doe@g.com', first_name: 'John', last_name: 'Doe', amount: 15 },
          { email: 'e.doe@g.com', first_name: 'Emily', last_name: 'Doe', amount: 10 },
        )
      end

      specify 'sort by first name and search by email' do
        get '/api/v1/messages', params: {
          search_key: 'email',
          search_value: 'doe',
          sort_key: 'first_name',
          sort_direction: 'desc'
        }

        expect(json_response).to contain_exactly(
          { email: 'doe@g.com', first_name: 'John', last_name: 'Doe', amount: 15 },
          { email: 'e.doe@g.com', first_name: 'Emily', last_name: 'Doe', amount: 10 },
        )
      end
    end
  end

  describe 'POST /api/v1/messages' do
    specify 'validates wrong params' do
      post '/api/v1/messages', params: {}

      expect(json_response).to include(
        {
          errors: {
            first_name: ["can't be blank"],
            last_name: ["can't be blank"],
            amount: ["can't be blank"],
            email: ["can't be blank", "format invalid"]
          }
        }
      )
    end

    specify 'create messages' do
      post '/api/v1/messages', params: {
        email: 'email@example.com',
        first_name: 'First Name',
        last_name: 'Last Name',
        amount: 500
      }

      expect(json_response).to include(
        {
          id: be_a(Integer),
          email: 'email@example.com',
          first_name: 'First Name',
          last_name: 'Last Name',
          amount: 500,
          created_at: be_a(String),
          updated_at: be_a(String)
        }
      )
    end
  end
end
