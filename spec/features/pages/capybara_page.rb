class CapybaraPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def reload
    visit current_path
  end

  protected

  def find_parent(node)
    node.first(:xpath, './/..')
  end
end
