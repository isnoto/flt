require 'features/pages/capybara_page'

class MessagesIndexPage < CapybaraPage
  def visit_page
    visit messages_path
  end

  def search_by(field:, value:)
    select(field, from: 'search-key-select')
    fill_in('Search', with: value)
    click_button('Search')
  end

  def sort_by(col_name)
    click_link(col_name)
  end

  def messages
    page.document.synchronize do
      all('[data-test-message]').map do |message_wrapper|
        within message_wrapper do
          {
            first_name: message_wrapper.find('[data-test-first_name]').text,
            last_name: message_wrapper.find('[data-test-last_name]').text,
            email: message_wrapper.find('[data-test-email]').text,
            amount: message_wrapper.find('[data-test-amount]').text
          }
        end
      end
    end
  end
end
