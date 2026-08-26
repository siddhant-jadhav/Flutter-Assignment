class DatabaseManager {
  late final String connectionString = _initConnection();

  String _initConnection() {
    print('Connecting to Database...');
    return "postgres://localhost:5432/db";
  }
}

Never failWithUnreachable(String reason) {
  throw ArgumentError("Fatal Application Error: $reason");
}

void processInput(Object? input) {
  if (input == null) {
    failWithUnreachable("Input cannot be null");
  }
  print('Input type promoted length: ${input.toString().length}');
}

class Cache {
  String? _cachedData;

  void setData(String data) {
    _cachedData = data;
  }

  void validateCache() {
    final localData = _cachedData;
    if (localData != null) {
      print('Cache data length: ${localData.length}');
    }
  }
}

class LateHolder {
  late String unassignedText;
}

int getScoresCount(Map<String, List<int>?>? data) {
  return data?['scores']?.length ?? -1;
}

void main() {
  var db = DatabaseManager();
  print('DatabaseManager created without trigger.');
  print('Accessing connection: ${db.connectionString}');

  try {
    processInput(null);
  } catch (e) {
    print('Caught expected failWithUnreachable error: $e');
  }
  processInput("Valid input data");

  var cache = Cache();
  cache.setData("Cached response payload");
  cache.validateCache();

  var lateHolder = LateHolder();
  try {
    print(lateHolder.unassignedText);
  } catch (e) {
    print('Caught LateInitializationError: $e');
  }
  lateHolder.unassignedText = "Initialized Value";
  print('unassignedText: ${lateHolder.unassignedText}');

  Map<String, List<int>?>? complexData;
  print('Scores count when data is null: ${getScoresCount(complexData)}');

  complexData = {
    'scores': [100, 95, 88]
  };
  print('Scores count after assignment: ${getScoresCount(complexData)}');

  String? conditionalNullable = DateTime.now().millisecond >= 0 ? "Dart 3 Sound Null Safety" : null;
  if (conditionalNullable != null) {
    print(conditionalNullable.toUpperCase());
  }
}
