class SearchResult {
  String title;
  String genre;
  String year;
  String rating;
  String url;
  String muId;

  SearchResult(this.title,this.genre, this.year, this.rating, this.url) {
    RegExp id = new RegExp(r'\d+');
    this.muId = id.stringMatch(this.url);
  }
}
