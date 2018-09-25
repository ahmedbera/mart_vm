import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mart_vm/parser/mangaParser.dart';
import 'package:mart_vm/models/manga.dart';
import 'package:mart_vm/models/searchOptions.dart';
import 'package:mart_vm/parser/searchResultsParser.dart';

class Mart {
  static Future<Manga> getMangaById(id) async {
    var url = "https://www.mangaupdates.com/series.html?id="+id;
    return makeRequest(url).then((res) {
      return parseManga(res);
    });
  }

  static Future<List> searchMangaByString(String searchTerm, [page=1]) async {
    var url = "http://www.mangaupdates.com/series.html?page=" + page.toString() + "&stype=title&search=" + searchTerm.replaceAll(' ', '+');
    return makeRequest(url).then((res) {
      return parseSearchResults(res);
    });
  }

  static Future<List> advancedSearch(SearchOptions options, [page=1]) async {
    return makeRequest(options.url).then((res) {
      return parseSearchResults(res);
    });
  }

  static Future<String> makeRequest(url) async {
    return http.read(url).then((result) {
      return result;
    });
  }
}