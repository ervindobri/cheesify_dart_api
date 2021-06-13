enum Class { FRESH, SOFT, FIRM, SEMIFIRM, BLUE }
enum Attributes { FIRM, SPICY, CREAMY, MOLDY, SMOKED }
enum Scale { VERYLOW, LOW, MID, HIGH, VERYHIGH }

Class? getClassFromString(String classAsString) {
  for (Class element in Class.values) {
    if (element.toString() == classAsString) {
      return element;
    }
  }
  return null;
}

Attributes? getAttributesFromString(String classAsString) {
  for (var element in Attributes.values) {
    if (element.toString() == classAsString) {
      return element;
    }
  }
  return null;
}

Scale? getScaleFromString(String classAsString) {
  for (Scale element in Scale.values) {
    if (element.toString() == classAsString) {
      return element;
    }
  }
  return null;
}

List<Attributes> getAttributesFromList(var json) {
  var attributes = <Attributes>[];
  for (var element in Attributes.values) {
    if (json.contains(element.toString())) {
      attributes.add(element);
    }
  }
  return attributes;
}

List<String> getFactsFromList(var json) {
  var list = <String>[];
  for (var item in json) {
    list.add(item.toString());
  }
  return list;
}

class Cheese {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final Class cheeseClass;
  final List<Attributes> attributes;
  final Scale fatScale;
  final Scale textureScale;
  final Scale agingScale;
  final Scale proteinScale;
  final List<String> facts;

  Cheese(
      {required this.id,
      required this.name,
      this.shortDescription = "",
      this.longDescription = "",
      this.fatScale = Scale.MID,
      this.textureScale = Scale.MID,
      this.agingScale = Scale.MID,
      this.proteinScale = Scale.MID,
      required this.cheeseClass,
      required this.attributes,
      this.facts = const []});

  factory Cheese.fromJson(Map<String, dynamic> json) {
    return Cheese(
      id: json['id'] as int,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      fatScale: getScaleFromString(json['fatScale']) as Scale,
      textureScale: getScaleFromString(json['textureScale']) as Scale,
      agingScale: getScaleFromString(json['agingScale']) as Scale,
      proteinScale: getScaleFromString(json['proteinScale']) as Scale,
      cheeseClass: getClassFromString(json['cheeseClass']) as Class,
      attributes: getAttributesFromList(json['attributes']),
      facts: getFactsFromList(json['facts']),
    );
  }

  Map<String, dynamic> toJson() {
    // print("Converting cheese to json!");
    return {
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'fatScale': fatScale.toString(),
      'textureScale': textureScale.toString(),
      'agingScale': agingScale.toString(),
      'proteinScale': proteinScale.toString(),
      'cheeseClass': cheeseClass.toString(),
      'attributes': attributes.map((e) => e.toString()).toList(), //list
      'facts': facts.map((e) => e.toString()).toList(), //list
    };
  }
}
