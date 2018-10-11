import 'dart:async';
import 'dart:math';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mart_vm/parser/mangaParser.dart';
import 'package:mart_vm/parser/searchResultsParser.dart';
import 'package:mart_vm/parser/authorParser.dart';
import 'package:mart_vm/parser/userList.dart';
import 'package:mart_vm/parser/seriesStats.dart';
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

  static Future getSeriesStats([String period="month1", String page="1"]) async {
    var url = "https://www.mangaupdates.com/stats.html?period="+ period + "&page="+ page;
    //var url = "https://www.mangaupdates.com/stats.html";
    return makeRequest(url).then((res) {
      return parseSeriesStatsPage(res);
    });
  }

  static Future updateLists({
    @required String id,
    @required String type,
    listId,
    bool delete=false,
    int chapter,
    int volume
  }) async {
    /** @required params
     * id: manga id
     * cache_j={number},{number},{number} 3, 8 character random number
     * type=["list", "chap"]
     * * * Update list
     * l: list id (0 is delete/not in list)
     * r: remove (probably)
     * inc_c: increment chapter (can be negative)
     * inc_v: increment volume (can be negative)
     * * * Set list
     * set_c: set chapter number
     * set_v: set volume number
     * if r=1 is used also use inc_c=1 and inc_v=1
     */
    if(Mart.cookie == '') {
      throw new StateError("Cookie has not been found.");
    }
    String list_update = 'https://www.mangaupdates.com/ajax/list_update.php?s=${id}';
    String chap_update = 'https://www.mangaupdates.com/ajax/chap_update.php?s=${id}';
    String list_id = listId == null ? '' : '&l=${listId}';
    String remove = delete ? '&l=0&r=1' : '';
    String inc_c = chapter == null ? '' : '&inc_c=${chapter}';
    String inc_v = volume == null ? '' : '&inc_v=${volume}';
    String set_c = chapter == null ? '' : '&set_c=${chapter}';
    String set_v = volume == null ? '' : '&set_v=${volume}';
    String cache = '&cache_j=';

    String url = '';
    if(type == "list") {
      url = list_update;
      url += list_id;
      url += remove;
      url += inc_c;
      url += inc_v;
    } else if(type == "chap") {
      url = chap_update;
      url += set_c;
      url += set_v;
    }
    // Generate cache
    Random rnd = new Random();
    for (var i = 0; i < 26; i++) {
      if(i == 8 || i == 17) {
        cache += ',';
      } else {
        cache += rnd.nextInt(10).toString();
      }
    }
    
    url += cache;
    // print(url);
    return makeRequest(url).then((res) {
      return res;
    });
  }
  // TODO: write AjaxResponse class
  static Future chapterIncrement([String id, int increment=1]) async {
    return updateLists(id: id, chapter: increment, type: "list");
  }
  static Future volumeIncrement([String id, int increment=1]) async {
    return updateLists(id: id, volume: increment, type: "list");
  }
  static Future removeManga([String id]) async {
    return updateLists(id: id, type: "list", delete: true);
  }
  static Future chapterUpdate({String id, int chapter, int volume}) async {
    return updateLists(id: id, type: "chap", chapter: chapter, volume: volume);
  }
  static Future moveToList(String id, listId) async {
    // TODO: investigate inc/set params work during list updates
  }


  static Future<String> makeRequest(url) async {
    return http.read(url, headers: {
      "cookie" : cookie
    }).then((result) {
      return result;
    }).catchError((err) {
      print(err);
    });
  }
}