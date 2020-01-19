class FindMessagesQuery
  DEFAULT_SORT_KEY = 'created_at'
  DEFAULT_SORT_DIRECTION = 'asc'
  ALLOWED_SORT_DIRECTIONS = ['asc', 'desc']
  ALLOWED_SEARCH_FIELDS = ['email', 'last_name']

  def initialize(relation = Message.all)
    @relation = relation
  end

  def call(params)
    records = @relation
    records = search(records, params.slice(:search_key, :search_value)) if params[:search_key].present?
    records = sort(records, params.slice(:sort_key, :sort_direction)) if params[:sort_key].present?
    records
  end

  private

  def search(relation, params)
    return relation if params.blank?
    return relation unless ALLOWED_SEARCH_FIELDS.include?(params[:search_key])
    search_field = prepare_search_column(params[:search_key])

    relation.where("#{search_field} LIKE :query", { query: "%#{params[:search_value]}%" })
  end

  def sort(relation, params)
    return relation.order(DEFAULT_SORT_KEY => DEFAULT_SORT_DIRECTION) if params.blank?

    key = prepare_sort_key(params[:sort_key])
    direction = prepare_sort_direction(params[:sort_direction])

    relation.order(key => direction)
  end

  def prepare_sort_key(key)
    @relation.column_names.include?(key) ? key : DEFAULT_SORT_KEY
  end

  def prepare_sort_direction(direction)
    direction = direction.downcase
    ALLOWED_SORT_DIRECTIONS.include?(direction) ? direction : DEFAULT_SORT_DIRECTION
  end

  def prepare_search_column(col_name)
    ActiveRecord::Base.connection.quote_column_name(col_name)
  end
end
