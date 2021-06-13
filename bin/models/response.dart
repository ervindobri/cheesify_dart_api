import 'cheese.dart';

//SECTION 2 -- Our response model
class ResponseModel {
  final int totalRows;
  final int page;
  final List<Cheese> cheeses;

  ResponseModel(this.totalRows, this.page, this.cheeses);

  Map<String, dynamic> toJson() {
    return {
      'total': totalRows,
      'page': page,
      'cheeses': cheeses.map((e) => e.toJson()).toList()
    };
  }
}
