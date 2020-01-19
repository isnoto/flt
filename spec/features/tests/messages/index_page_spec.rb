require 'features/pages/messages/messages_index_page'

feature 'Index Page', js: true do
  let(:page) { MessagesIndexPage.new }

  before do
    create(:message, first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5)
    create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
    create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)
    create(:message, first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 15)
  end

  scenario 'display messages' do
    page.visit_page

    expect(page.messages).to contain_exactly(
      { first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: '5' },
      { first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: '5' },
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' },
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' }
    )
  end

  scenario 'search by last name' do
    page.visit_page
    page.search_by(field: 'Last Name', value: 'doe')

    expect(page.messages).to contain_exactly(
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' },
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' }
    )
  end

  scenario 'search by email' do
    page.visit_page
    page.search_by(field: 'Email', value: 'scott@example.com')

    expect(page.messages).to contain_exactly(
      { first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: '5' },
    )
  end

  scenario 'sort by amount' do
    page.visit_page

    page.visit_page
    page.search_by(field: 'Email', value: 'g.com')
    page.sort_by('Amount')

    expect(page.messages).to contain_exactly(
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' },
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' }
    )

    page.sort_by('Amount')

    expect(page.messages).to contain_exactly(
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' },
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' }
    )
  end

  scenario 'sort by first name' do
    page.visit_page
    page.search_by(field: 'Last Name', value: 'Doe')
    page.sort_by('First Name')

    expect(page.messages).to contain_exactly(
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' },
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' }
    )

    page.sort_by('First Name')

    expect(page.messages).to contain_exactly(
      { first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: '15' },
      { first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: '10' }
    )
  end
end
