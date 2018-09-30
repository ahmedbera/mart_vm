import 'package:mart_vm/models/options.dart';

// https://github.com/ahmedbera/mudroid/blob/master/src/lib/Mangaupdates.js
class SearchOptions {
  String url = "https://www.mangaupdates.com/series.html?";
  String genresInclude = "genre=";
  String genresExclude = "&exclude_genre=";
  String licensed = '';
  String categories = '';
  String filter = '';
  // ▲▲▲ "scanlated" "completed" "oneshots" "no_oneshots" "some_releases" "no_releases" ▲▲▲ //

  String type = '';
  // ▲▲▲ "Artbook" "Doujinshi" "Drama CD" "Manga" "Manhwa" "Manhua" "Thai" "Indonesian" "Novel" "OEL" "Filipino" ▲▲▲ //

  String list = null; // Not yet

  SearchOptions({
    List genresInclude,
    List genresExclude,
    bool licensed,
    FilterOption filterOption,
    TypeOption typeOption,
    List categories}) {

    // Build included genres string
    if (genresInclude != null && genresInclude.length > 0) {
      genresInclude.forEach((genre) {
        this.genresInclude += genre + "_";
      });
      this.genresInclude = this.genresInclude.replaceAll(new RegExp(r'_$'), '');
    }

    // Build excluded genres string
    if (genresExclude != null && genresExclude.length > 0) {
      genresExclude.forEach((genre) {
        this.genresExclude += genre + "_";
      });
      this.genresExclude = this.genresExclude.replaceAll(new RegExp(r'_$'), '');
    }

    if (categories != null && categories.length > 0) {
      categories.forEach((cat) {
        this.categories += cat + "_";
      });
      this.categories = this.categories.replaceAll(new RegExp(r'_$'), '');
    }

    // License, filters, type string
    this.licensed =
        licensed == null ? '' : licensed ? "&licensed=yes" : "&licensed=no";
  
    if(filterOption.value != null)
      this.filter = "&filter=" + filterOption?.value;
    if(typeOption.value != null)
      this.type = "&type=" + typeOption?.value;

    // Build url
    this.url = this.url +
        this.genresInclude +
        this.genresExclude +
        this.categories +
        this.type +
        this.filter +
        this.licensed;
  }
}
