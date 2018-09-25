import 'package:html/parser.dart';
import 'package:mart_vm/models/author.dart';

parseAuthorPage(response) {
  var document = parse(response).body;
  Author author = new Author();

  author.name = document.querySelector('.tabletitle').text;
  author.imageUrl = document.querySelector('tr[valign=top] img')?.attributes['src'];
  document.querySelectorAll('tr[valign=top]').last.querySelectorAll('tr').forEach((element) {
    if(element.text.contains("Associated Names")) {
      author.associatedNames = element.nextElementSibling.text.trim();
    } else if (element.text.contains("Name (in native language)")) {
      author.nativeName = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Birth Place")) {
      author.birthPlace = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Birth Date")) {
      author.birthday = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Zodiac")) {
      author.zodiac = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Last Updated")) {
      author.lastUpdated = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Comments")) {
      author.comments = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Blood Type")) {
      author.bloodType = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Gender")) {
      author.gender = element.nextElementSibling.text.trim();
    } else if ( element.text.contains("Official Website")) {
      if(element.nextElementSibling.querySelector('a') != null) {
        author.website = element.nextElementSibling.querySelector('a').attributes['href'];
      }
    } else if ( element.text.contains("Twitter")) {
      if(element.nextElementSibling.querySelector('a') != null) {
        author.twitter = element.nextElementSibling.querySelector('a').attributes['href'];
      }
    } else if ( element.text.contains("Facebook")) {
      if(element.nextElementSibling.querySelector('a') != null) {
        author.facebook = element.nextElementSibling.querySelector('a').attributes['href'];
      }
    }
  });
  return author;
}