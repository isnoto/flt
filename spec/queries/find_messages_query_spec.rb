describe FindMessagesQuery do
  it 'allows to search by last name' do
    create(:message, first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 5)
    create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
    create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)

    result = subject.call(search_key: 'last_name', search_value: 'doe')

    expect(result).to contain_exactly(
      have_attributes(first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 5),
      have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10),
    )
  end

  it 'allows to search by email' do
    create(:message, first_name: 'Lucie', last_name: 'Doe', email: 'lucie.doe@g.com', amount: 5)
    create(:message, first_name: 'David', last_name: 'Johnson', email: 'jonson.test@mail.com', amount: 5)

    result = subject.call(search_key: 'email', search_value: 'JONsoN')

    expect(result).to contain_exactly(
      have_attributes(first_name: 'David', last_name: 'Johnson', email: 'jonson.test@mail.com', amount: 5),
    )
  end

  it 'ignores not allowed search key' do
    create(:message, first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 5)
    create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
    create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)

    result = subject.call(search_key: 'first_name', search_value: 'John')

    expect(result).to contain_exactly(
      have_attributes(first_name: 'John', last_name: 'Doe', email: 'doe@g.com', amount: 5),
      have_attributes(first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5),
      have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10),
    )
  end

  context 'sort by first_name' do
    before do
      create(:message, first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5)
      create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
      create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)
    end

    it 'sorts message by first name ASC' do
      result = subject.call(sort_key: 'first_name', sort_direction: 'asc')

      expect(result).to contain_exactly(
        have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10),
        have_attributes(first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5),
        have_attributes(first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5),
      )
    end

    it 'sorts message by first name DESC' do
      result = subject.call(sort_key: 'first_name', sort_direction: 'desc')

      expect(result).to contain_exactly(
        have_attributes(first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5),
        have_attributes(first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5),
        have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10),
      )
    end
  end

  context 'sort by email' do
    before do
      create(:message, first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5)
      create(:message, first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
      create(:message, first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)
    end

    it 'sorts message by email ASC' do
      result = subject.call(sort_key: 'email', sort_direction: 'asc')

      expect(result).to contain_exactly(
        have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10),
        have_attributes(first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5),
        have_attributes(first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5)
      )
    end

    it 'sorts message by email DESC' do
      result = subject.call(sort_key: 'email', sort_direction: 'desc')

      expect(result).to contain_exactly(
        have_attributes(first_name: 'John', last_name: 'Watson', email: 'watson@e.com', amount: 5),
        have_attributes(first_name: 'Scott', last_name: 'Asd', email: 'scott@example.com', amount: 5),
        have_attributes(first_name: 'Emily', last_name: 'Doe', email: 'e.doe@g.com', amount: 10)
      )
    end
  end
end
