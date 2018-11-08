import 'package:mart_vm/models/manga.dart';
import 'package:mart_vm/models/genericLink.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

parseManga(String response) {
  var document = parse(response).body;
  Manga manga = new Manga();

  // Manga title
  manga.title = document.querySelector('.releasestitle.tabletitle').text;

  //mu işd
  manga.id = document.querySelector('input[name="id"]').attributes['value'];

  // Tags
  document.querySelectorAll('.tag_normal a').forEach((tag) {
    manga.tags.add(new GenericLink(tag.text, tag.attributes['href']));
  });

  // List status
  var status = document.querySelector('#showList a');
  if (status.text == "Add to reading list") {
    manga.listInfo.inList = false;
  } else {
    try {
      manga.listInfo.currentListName = status.text;
      manga.listInfo.currentListId = status.attributes['href'].split("=").last;
      if (manga.listInfo.currentListName == "Reading List") {
        manga.listInfo.readVolumes =
            document.querySelector('[title="Increment Volume"]').text;
        manga.listInfo.readChapters =
            document.querySelector('[title="Increment Chapter"]').text;
      }
    } catch (e) {}
  }

  List<Element> content = document.querySelectorAll('div.sContent');
  print(content);

  manga.description = content[0].text;
  manga.type = content[1].text.trim();

  // * related series: content[2];

  /* Associated Names */
  content[3].nodes.forEach((node) {
    if (node.nodeType == 3) {
      manga.associatedNames.add(node.text);
    }
  });
  manga.associatedNames.removeLast();

  /* Groups Scanlating */
  content[4].querySelectorAll('a').forEach((a) {
    var groupName = a.text;
    if (groupName != 'More...' && groupName != 'Less...') {
      manga.groupsScanlating
          .add(new GenericLink(groupName, a.attributes['href']));
    }
  });

  /* Latest Releases */
  if (content[5].children.length > 3) {
    manga.latestReleases.add({
      "Chapter": content[5].children[0].text,
      "Group": new GenericLink(content[5].children[1].text,
          content[5].children[1].attributes['href']),
      "Date": content[5].children[2].text
    });
  }
  if (content[5].children.length > 8) {
    manga.latestReleases.add({
      "Chapter": content[5].children[4].text,
      "Group": new GenericLink(content[5].children[5].text,
          content[5].children[5].attributes['href']),
      "Date": content[5].children[6].text
    });
  }
  if (content[5].children.length > 12) {
    manga.latestReleases.add({
      "Chapter": content[5].children[8].text,
      "Group": new GenericLink(content[5].children[9].text,
          content[5].children[9].attributes['href']),
      "Date": content[5].children[10].text
    });
  }

  // https://www.mangaupdates.com/releases.html?search=70263&stype=series
  // "Search for all releases of this series"

  manga.status = content[6].text.trim();
  manga.scanlated = content[7].text.contains('Yes') ? true : false;

  // * anime start/end : content[8]
  // * user ratings : content[9]
  // * forum : content[10]

  /* User rating */
  UserRating rating = new UserRating();
  RegExp voters = new RegExp(r'\((\d)*');
  RegExp average = new RegExp(r'\d\.\d');
  RegExp percent = new RegExp(r'\d+');
  rating.average = average.stringMatch(content[11].nodes[0].text);
  rating.voters = voters.stringMatch(content[11].nodes[0].text);
  rating.voters = rating.voters.substring(1);
  rating.bayesianAverage = content[11].nodes[3].text;

  var i = 10;
  content[11].querySelectorAll('tr span').forEach((r) {
    rating.distribution.add({
      "rate": i.toString(),
      "votes": voters.stringMatch(r.text).substring(1),
      "percent": percent.stringMatch(r.text)
    });
    i--;
  });

  manga.score = rating;

  /* Last Updated */
  manga.lastUpdated = content[12].text.trim();

  /* Image */
  var img = content[13].querySelector('img');
  try {
    manga.imgUrl = img.attributes['src'];
  } catch (e) {
    manga.imgUrl = null;
  }

  /* Genre */
  content[14].querySelectorAll('a').forEach((a) {
    var u = a.querySelector('u');
    manga.genres.add(new GenericLink(u.text, a.attributes["href"]));
  });

  /* Categories */
  content[15].querySelectorAll('ul li a').forEach((a) {
    if (a.attributes['rel'] == "nofollow") {
      manga.categories.add(new GenericLink(a.text, a.attributes['href']));
    }
  });

  /* Category recommendations */
  content[16].querySelectorAll('a').forEach((a) {
    var recName = a.text;
    if (recName != 'More...' && recName != 'Less...') {
      manga.categoryRecommendations
          .add(new GenericLink(recName, a.attributes['href']));
    }
  });

  /* Recommendations */
  content[17].querySelectorAll('a').forEach((a) {
    var recName = a.text;
    if (recName != 'More...' && recName != 'Less...') {
      manga.recommendations.add(new GenericLink(recName, a.attributes['href']));
    }
  });

  /* Authors */
  content[18].querySelectorAll('a').forEach((a) {
    manga.authors.add(new GenericLink(a.text, a.attributes['href']));
  });

  /* Artists */
  content[19].querySelectorAll('a').forEach((a) {
    manga.artists.add(new GenericLink(a.text, a.attributes['href']));
  });

  /* Year */
  manga.year = content[20].text.trim();

  var publisher = content[21].querySelector('a');
  if (publisher != null && publisher.text != '') {
    manga.originalPublisher =
        new GenericLink(publisher.text, publisher.attributes['href']);
  }

  // * Serialized In (magazine) : content[22]

  manga.licensed = content[23].text.contains('Yes') ? true : false;

  /* English Publisher */
  if (content[24].querySelector('a') != null) {
    manga.englishPublisher = new GenericLink(content[24].text.trim(),
        content[24].querySelector('a').attributes['href']);
  }

  // *  Activity Stats (vs. other series) : content[25]
  // *  List Stats : content[26]

  return manga;
}
