import 'package:mart_vm/Static/genres.dart';
import 'package:mart_vm/Static/licenseOptions.dart';
import 'package:mart_vm/Static/filterOptions.dart';
import 'package:mart_vm/Static/typeOptions.dart';

class Statics {
  static List<LicenseOption> licenseOptions = licenseOptionsMap;
  static List<String> genreList = genres;
  static List<FilterOption> filterOptions = filterOptionsList;
  static List<TypeOption> typeOptions = typeOptionsList;
}