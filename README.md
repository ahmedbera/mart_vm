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
After that run `pub get` or `flutter packages get` depending on your platform.
Although isn't tested it should be safe to use in Flutter/Web/Server

## How do I use it
So far all functions are `static` so need to initialize anything.
```dart
import 'package:mart_vm/mart.dart';

Mart.getMangaById("70263").then((res) {
    // returns Manga
    // you can see Manga class in /Models/manga.dart
});

Mart.searchMangaByString("horimiya").then((res) {
    // Returns an array of `SearchResult`
});

```

## What can mart do so far
- [x] Parse Manga details page
- [x] Basic search
- [x] Advanced search
- [ ] Parse user lists
- [ ] Parse scan groups
- [ ] Parse artist/author page

These are the basic features I've planned so far

### Dependencies
+ [html](https://pub.dartlang.org/packages/html)
+ [http](https://pub.dartlang.org/packages/http)

#### Why name?
**ma**ngaupdates + d**art vm** 