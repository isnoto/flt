class MessageFilter {
  constructor(searchForm) {
    this.searchForm = searchForm;
    this.searchUrl = searchForm.getAttribute('data-search-url');
    this.directionIconSelector = '[data-direction-icon]';
    this.sortFields = document.querySelectorAll('[data-sort-field]');
    this.searchKeyField = document.querySelector('[data-search-key]');
    this.searchValueField = document.querySelector('[data-search-value]');
    this.messagesContainerEl = document.querySelector('[data-messages-container-el]');
    this.activeSortField = document.querySelector('.active-sort-field');
    this.currentSearchAttrs = this.defaultSearchAttrs(this.searchKeyField);
  }

  defaultSearchAttrs(searchKeyField) {
    return {
      searchKey: searchKeyField.options[searchKeyField.selectedIndex].value,
      searchValue: '',
      sortKey: '',
      sortDirection: ''
    }
  };

  async init() {
    const ctx = this;

    this.searchForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      await ctx.search();
    });

    this.sortFields.forEach((sortField) => {
      sortField.addEventListener('click', async (e) => {
        e.preventDefault();

        await ctx.setSort(e.currentTarget);
        await ctx.search();
      })
    });

    this.searchKeyField.addEventListener('change', (e) => {
      e.preventDefault();
      ctx.currentSearchAttrs.searchKey = e.target.value;
    });

    this.searchValueField.addEventListener('change', (e) => {
      e.preventDefault();
      ctx.currentSearchAttrs.searchValue = e.target.value.trim();
    })
  }

  async search() {
    const response = await fetch(this.getSearchUrl());
    const messagesData = await response.json();

    this.appendMessagesData(messagesData);
  }

  setSort(sortEl) {
    this.setActiveSortField(sortEl);
    this.setActiveAttrsSort();
    this.setActiveDirectionClassNames();
  }

  setActiveSortField(element) {
    if (this.activeSortField) {
      this.activeSortField.querySelector(this.directionIconSelector).setAttribute('class' , '');
    }

    this.activeSortField = element;
    this.activeSortField.setAttribute('data-sort-direction', this.getSortDirection());
  }

  setActiveDirectionClassNames() {
    const classNames = this.currentSearchAttrs.sortDirection === 'asc'
      ? ['fas', 'fa-arrow-down']
      : ['fas', 'fa-arrow-up'];

    this.activeSortField.querySelector(this.directionIconSelector).classList.add(...classNames);
  }

  setActiveAttrsSort() {
    this.currentSearchAttrs.sortKey = this.activeSortField.getAttribute('data-sort-key');
    this.currentSearchAttrs.sortDirection = this.activeSortField.getAttribute('data-sort-direction');
  }

  getSortDirection() {
    return this.currentSearchAttrs.sortDirection === 'asc'
      ? 'desc'
      : 'asc'
  }

  getSearchUrl() {
    const url = new URL(this.searchUrl);

    url.searchParams.append('search_key', this.currentSearchAttrs.searchKey);
    url.searchParams.append('search_value', this.currentSearchAttrs.searchValue);
    url.searchParams.append('sort_key', this.currentSearchAttrs.sortKey);
    url.searchParams.append('sort_direction', this.currentSearchAttrs.sortDirection);

    return url.toString();
  }

  appendMessagesData(messagesData) {
    const fragment = document.createDocumentFragment();
    messagesData.forEach((messageData) => {
      return fragment.appendChild(this.formatMessage(messageData));
    });

    this.messagesContainerEl.innerHTML = '';
    this.messagesContainerEl.appendChild(fragment);
  }

  formatMessage(message) {
    const msgWrapper = document.createElement('tr');
    msgWrapper.setAttribute('data-test-message', 'true');

    for (let [key, value] of Object.entries(message)) {
      const element = document.createElement('td');

      element.innerHTML = value;
      element.setAttribute(`data-test-${key}`, 'true');
      msgWrapper.appendChild(element);
    }

    return msgWrapper;
  }
}

document.addEventListener('turbolinks:load', async () => {
  const searchForm = document.querySelector('[data-search-form]');

  if (searchForm) {
    const filter = new MessageFilter(searchForm);
    await filter.init();
  }
});
