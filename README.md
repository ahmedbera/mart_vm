# mart_vm

## What is this?
It's a `Dart` port of my old mangaupdates.com parser which was in javascript.
Old parser can be found [here.](https://github.com/ahmedbera/mudroid/blob/master/src/lib/Mangaupdates.js)

## How do I install it
```bash
git clone https://github.com/ahmedbera/mart_vm
```
After cloning your repository open `pubspec.yaml` file of the project you want to use parser in it and add
```yaml
dependencies:
    mart_vm:
        path: /path/to/mart_vm
```
Although isn't tested you should be able to use
```yaml
dependencies:
    mart_vm:
        git:
            url: git://github.com/ahmedbera/mart_vm.git
```
After that run `pub get` or `flutter packages get` depending on your platform.
It is tested in Flutter and it should work in server/client side.

## How do I use it
So far all functions are `static` so need to initialize anything.
```dart
import 'package:mart_vm/mart.dart';

Mart.getMangaById("70263").then((res) {
    // returns Manga
    // you can see Manga class in /models/manga.dart
});

Mart.searchMangaByString("horimiya").then((res) {
    // Returns an array of `SearchResult`
});

```

## API
All functions return a `Future`
```dart

/*  
    login:
    After successful login it updates Mart.cookie param and sends saved cookie with every request.
    Saving cookie value between session (ie closing/opening app) is in developers responsibility.
*/
Future<bool> login(username, password)

Future<Manga> getMangaById(id)
Future<Author> getAuthorById(id)
Future<List> searchMangaByString(String searchTerm, [page=1])
Future<List> advancedSearch(SearchOptions options, [page=1])
Future<List> getMangaList([String listId="read"])
Future<List> parseSeriesStats([String period="month1", String page="1"])
```

## What can mart do so far
- [x] Parse Manga details page
- [x] Basic search
- [x] Advanced search
- [x] Parse user lists
- [x] Parse artist/author page
- [x] Parse Series Statistics page
- [ ] Parse What's New page
- [ ] Parse scan groups

These are the features I've planned so far.

### Dependencies
+ [html](https://pub.dartlang.org/packages/html)
+ [http](https://pub.dartlang.org/packages/http)

#### Why name?
**ma**ngaupdates + d**art vm** 