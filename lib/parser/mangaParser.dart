import 'package:mart_vm/models/manga.dart';
import 'package:mart_vm/models/genericLink.dart';
import 'package:html/parser.dart';

parseManga(String response) {
  var document = parse(response).body;
  Manga manga = new Manga();

  // Manga title
  manga.title = document.querySelector('.releasestitle.tabletitle').text;

  // Tags
  document.querySelectorAll('.tag_normal a').forEach((tag) {
    manga.tags.add(new GenericLink(tag.text, tag.attributes['href']));
  });

  // List status 
  var status = document.querySelector('#showList a');
  try {  
    manga.currentListName = status.text;
    manga.currentListId = status.attributes['href'].split("=").last;
    if(manga.currentListName == "Reading List") {
      manga.readVolumes = document.querySelector('[title="Increment Volume"]').text;
      manga.readChapters = document.querySelector('[title="Increment Chapter"]').text;
    }
  } catch (e) {}
  
  

  //we need to go deeper
  // The reason behind using 'contains' and '==' is
  // after logging in some sCat's have [Edit] in them.
  // Instead making string check another querySelector could be used
  document.querySelectorAll('div.sCat').forEach((element) {
    if (element.text.contains('Image')) {
      var img = element.nextElementSibling.querySelector('img');
      try {
        manga.imgUrl = img.attributes['src'];
      } catch (e) {
        manga.imgUrl = null;
      }
    } else if (element.text.contains('Description')) {
      manga.description = element.nextElementSibling.text;
    } else if (element.text.contains('Type')) {
      manga.type = element.nextElementSibling.text.trim();
    } else if (element.text.contains('Year')) {
      manga.year = element.nextElementSibling.text.trim();
    } else if (element.text.contains('Completely Scanlated?')) {
      manga.scanlated =
          element.nextElementSibling.text.contains('Yes') ? true : false;
    } else if (element.text.contains('Status in Country of Origin')) {
      manga.status = element.nextElementSibling.text.trim();
    } else if (element.text.contains('Genre')) {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        var u = a.querySelector('u');
        manga.genres.add(new GenericLink(u.text, a.attributes["href"]));
      });
    } else if (element.text.contains('Associated')) {
      element.nextElementSibling.nodes.forEach((node) {
        if(node.nodeType == 3) {
          manga.associatedNames.add(node.text);
        }
      });
      manga.associatedNames.removeLast();
    } else if (element.text.contains('Groups Scanlating')) {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        var groupName = a.text;
        if (groupName != 'More...' && groupName != 'Less...') {
          manga.groupsScanlating
              .add(new GenericLink(groupName, a.attributes['href']));
        }
      });
    } else if (element.text.contains('Category Recommendations')) {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        var recName = a.text;
        if (recName != 'More...' && recName != 'Less...') {
          manga.categoryRecommendations
              .add(new GenericLink(recName, a.attributes['href']));
        }
      });
    } else if (element.text == 'Recommendations') {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        var recName = a.text;
        if (recName != 'More...' && recName != 'Less...') {
          manga.recommendations
              .add(new GenericLink(recName, a.attributes['href']));
        }
      });
    } else if (element.text == 'Latest Release(s)') {
      if(element.nextElementSibling.children.length > 3){
        manga.latestReleases.add({
          "Chapter" : element.nextElementSibling.children[0].text,
          "Group" : new GenericLink(
            element.nextElementSibling.children[1].text,
            element.nextElementSibling.children[1].attributes['href']),
          "Date" : element.nextElementSibling.children[2].text
        });
      }
      if(element.nextElementSibling.children.length > 8) {
        manga.latestReleases.add({
          "Chapter" : element.nextElementSibling.children[4].text,
          "Group" : new GenericLink(
            element.nextElementSibling.children[5].text,
            element.nextElementSibling.children[5].attributes['href']),
          "Date" : element.nextElementSibling.children[6].text
        });
      }
      if(element.nextElementSibling.children.length > 12){
        manga.latestReleases.add({
          "Chapter" : element.nextElementSibling.children[8].text,
          "Group" : new GenericLink(
            element.nextElementSibling.children[9].text,
            element.nextElementSibling.children[9].attributes['href']),
          "Date" : element.nextElementSibling.children[10].text
        });
      }
      
      // https://www.mangaupdates.com/releases.html?search=70263&stype=series
      // "Search for all releases of this series"

    } else if (element.text == 'User Rating') {
      UserRating rating = new UserRating();
      RegExp voters = new RegExp(r'\((\d)*');
      RegExp average = new RegExp(r'\d\.\d');
      RegExp percent = new RegExp(r'\d+');
      rating.average = average.stringMatch(element.nextElementSibling.nodes[0].text);
      rating.voters = voters.stringMatch(element.nextElementSibling.nodes[0].text);
      rating.voters = rating.voters.substring(1);
      rating.bayesianAverage = element.nextElementSibling.nodes[3].text;

      var i = 10;
      element.nextElementSibling.querySelectorAll('tr span').forEach((r) {
        rating.distribution.add({
          "rate" : i.toString(),
          "votes": voters.stringMatch(r.text).substring(1),
          "percent" : percent.stringMatch(r.text)
        });
        i--;
      });

      manga.score = rating;
    } else if (element.text.contains('Author')) {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        manga.authors.add(new GenericLink(a.text, a.attributes['href']));
      });
    } else if (element.text.contains('Artist')) {
      element.nextElementSibling.querySelectorAll('a').forEach((a) {
        manga.artists.add(new GenericLink(a.text, a.attributes['href']));
      });
    } else if (element.text.contains('Original Publisher')) {
      var publisher = element.nextElementSibling.querySelector('a');
      if(publisher != null && publisher.text != '') {
        manga.originalPublisher = new GenericLink(publisher.text, publisher.attributes['href']);
      }
    } else if (element.text.contains('Licensed')) {
      manga.licensed =
          element.nextElementSibling.text.contains('Yes') ? true : false;
    } else if (element.text.contains('Last Updated')) {
      manga.lastUpdated = element.nextElementSibling.text.trim();
    } else if (element.text.contains('English')) {
      if(element.nextElementSibling.querySelector('a') != null) {
        manga.englishPublisher = new GenericLink(
          element.nextElementSibling.text.trim(),
          element.nextElementSibling.querySelector('a').attributes['href']
        );
      }
    } else if (element.text.contains('Categories')) {
      element.nextElementSibling.querySelectorAll('ul li a').forEach((a) {
        if(a.attributes['rel'] == "nofollow") {
          manga.categories.add(new GenericLink(a.text, a.attributes['href']));
        }
      });
    }
  });

  return manga;
}