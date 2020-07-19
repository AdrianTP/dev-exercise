/** For this exercise, you will need to build a simple Vue.js app to list the
 * given quotes. Please do not use any libraries or plugins to do this other
 * than the core Vue.js and, optionally, a library to fetch the quotes.
 *
 * You can assume that you only need to support modern web browsers, so feel
 * free to build the app using either the new ECMAScript 6 or the older
 * ECMAScript 5 ("plain" JavaScript) standard.
 *
 * Please provide the following functionality:
 * - Fetch quotes from the source quotes.json and display the available
 *   information in a list-like structure (table/list)
 * - Provide client-side pagination (up to 15 quotes per page)
 * - Provide a way to filter between game and movie quotes
 * - Provide a client-side search that filters by the quote text
*/

const app = new Vue({
  el: '#app',
  data() {
    return {
      h1: 'BenchPrep JavaScript Exercise',
      placeholder: 'Loading...',
      quotesUrl: 'https://gist.githubusercontent.com/benchprep/dffc3bffa9704626aa8832a3b4de5b27/raw/quotes.json',
      search: {
        categories: ['games', 'movies'],
        text: '',
      },
      pagination: {
        currentPageNum: 1,
        perPage: 15,
        pages: []
      },
      rawQuotes: []
    };
  },
  methods: {
    paginate(quotes) {
      let currentPageNum = this.pagination.currentPageNum,
          perPage = this.pagination.perPage,
          from = (currentPageNum * perPage) - perPage,
          to = (currentPageNum * perPage);

      return quotes.slice(from, to);
    },
    updatePaginationControls() {
      let numPages = Math.ceil(this.filteredQuotes.length / this.pagination.perPage),
          tempPages = [];

      for (let i = 1; i <= numPages; ++ i) {
        tempPages.push(i);
      }

      this.pagination.pages = tempPages;
    }
  },
  computed: {
    filteredQuotes() {
      return this.rawQuotes.filter(item => {
        let textMatched     = item.quote.toLowerCase().indexOf(this.search.text.toLowerCase()) > -1,
            categoryMatched = this.search.categories.indexOf(item.theme.toLowerCase()) > -1;

        return textMatched && categoryMatched;
      });
    },
    displayedQuotes() {
      return this.paginate(this.filteredQuotes);
    }
  },
  watch: {
    displayedQuotes() {
      this.updatePaginationControls();

      if (this.pagination.currentPageNum > this.pagination.pages.length) {
        this.pagination.currentPageNum = this.pagination.pages.length;
      }
    },
    filteredQuotes() {
      this.updatePaginationControls();

      this.pagination.currentPageNum = 1;
    }
  },
  async created() {
    const response = await fetch(this.quotesUrl),
          data = await response.json();

    if (data) {
      this.rawQuotes = data;
    }
  }
});