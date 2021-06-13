import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'models/cheese.dart';
import 'models/response.dart';

//SECTION 1 -- Build the file URL
final targetFile =
    File(path.join(path.dirname(Platform.script.toFilePath()), 'data.json'));

// SECTOIN 3 -- Sorting method for the data model
int sortCheeses(Cheese a, Cheese b, int sortIndex, bool asc) {
  late int result;
  switch (sortIndex) {
    case 1:
      result = a.id.compareTo(b.id);
      break;
    case 2:
      result = a.name.compareTo(b.name);
      break;
    case 3:
      result = a.shortDescription.compareTo(b.shortDescription);
      break;
    case 4:
      result = a.longDescription.compareTo(b.longDescription);
      break;
    case 5:
      result = a.fatScale.index.compareTo(b.fatScale.index);
      break;
    case 6:
      result = a.textureScale.index.compareTo(b.textureScale.index);
      break;
    case 7:
      result = a.agingScale.index.compareTo(b.agingScale.index);
      break;
    case 8:
      result = a.proteinScale.index.compareTo(b.proteinScale.index);
      break;
    case 9:
      result = a.cheeseClass.index.compareTo(b.cheeseClass.index);
      break;
    default:
      result = a.id.compareTo(b.id);
      break;
  }
  if (!asc) result *= -1;
  return result;
}

Future main() async {
  var server;
  var fileContent = await readFile();

  server = await bindServer(server);
  print('Listening on http://${server.address.address}:${server.port}/');

  await for (HttpRequest req in server) {
    req.response.headers.contentType = ContentType.json;
    //CORS Header, so the anybody can use this
    req.response.headers.add(
      'Access-Control-Allow-Origin',
      '*',
      preserveHeaderCase: true,
    );

    switch (req.uri.path) {
      case '/cheeses':
        handleCheeseRequest(req, fileContent);
        break;
      default:
        req.response.write(
          jsonEncode('Hello there! General Kenobi'),
        );
    }

    await req.response.close();
  }
}

Future<List<Cheese>> readFile() async {
  late final List<Cheese> fileContent;
  if (await targetFile.exists()) {
    print('Serving data from $targetFile');
    fileContent = (jsonDecode(await targetFile.readAsString()) as List<dynamic>)
        .map((e) => Cheese.fromJson(e))
        .toList();
  } else {
    print("$targetFile doesn't exists, stopping");
    exit(-1);
  }
  return fileContent;
}

Future<dynamic> bindServer(server) async {
  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5069);
  } catch (e) {
    print("Couldn't bind to port 5069: $e");
    exit(-1);
  }
  return server;
}

void handleCheeseRequest(HttpRequest req, List<Cheese> fileContent) {
  try {
    //Set response data list and parameters
    var responseData = setResponseData(req, fileContent);
    req.response.write(
      jsonEncode(responseData),
    );
  } catch (e) {
    print('Something went wrong: $e');
    req.response.statusCode = HttpStatus.internalServerError;
  }
}

ResponseModel setResponseData(HttpRequest req, List<Cheese> content) {
  //Set parameters
  // final offset = int.parse(req.requestedUri.queryParameters['offset'] ?? '0');
  final pageSize =
      int.parse(req.requestedUri.queryParameters['pageSize'] ?? '10');
  final page = int.parse(req.requestedUri.queryParameters['page'] ?? '1');
  final sortIndex =
      int.parse(req.requestedUri.queryParameters['sortIndex'] ?? '1');
  final sortAsc =
      int.parse(req.requestedUri.queryParameters['sortAsc'] ?? '1') == 1;

  content.sort((a, b) => sortCheeses(a, b, sortIndex, sortAsc));
  // print(content.skip(offset).take(pageSize).toList());
  return ResponseModel(
    content.length,
    page,
    content.skip((page - 1) * pageSize).take(pageSize).toList(),
  );
}
