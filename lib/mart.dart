import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mart_vm/parser/mangaParser.dart';
import 'package:mart_vm/parser/searchResultsParser.dart';
import 'package:mart_vm/parser/authorParser.dart';
import 'package:mart_vm/parser/userList.dart';
import 'package:mart_vm/models/manga.dart';
import 'package:mart_vm/models/author.dart';
import 'package:mart_vm/models/searchOptions.dart';


class Mart {
  static String cookie = '';

  static Future<bool> login(username, password) async {
    var url = 'https://www.mangaupdates.com/login.html?' + 'act=login&username=' + username + '&password=' + password + '&x=0&y=0';

    var response = await http.post(url);
    
    String headers = '';
    response.headers.forEach((key, value){
      if(key == 'set-cookie') {
        headers = value;
      }
    });

    RegExp secure_blastvisit = new RegExp(r'secure_blastvisit=\w*;');
    RegExp secure_session = new RegExp(r'secure_session=\w*;');

    var blastvisit = secure_blastvisit.stringMatch(headers);
    var session = secure_session.allMatches(headers).last.group(0);

    if(blastvisit != null && session != null) {
      Mart.cookie = session + blastvisit;
      return true;
    } else {
      return false;
    }
  }

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

  static Future<Author> getAuthorById(id) async {
    var url = "https://www.mangaupdates.com/authors.html?id="+id;
    return makeRequest(url).then((res) {
      return parseAuthorPage(res);
    });
  }

  static Future getMangaList([String listId="read"]) {
    var url = "https://www.mangaupdates.com/mylist.html?list=" + listId;
    return makeRequest(url).then((res) {
      return parseUserList(res);
    });
  }

  static Future<String> makeRequest(url) async {
    return http.read(url, headers: {
      "cookie" : cookie
    }).then((result) {
      return result;
    });
  }
}