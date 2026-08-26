class APIConfig {
  final String endpoint;
  final int timeoutSeconds;
  final bool enableLogs;

  APIConfig({
    required this.endpoint,
    this.timeoutSeconds = 30,
    this.enableLogs = false,
  });
}

void sendNotification(
  String recipient, {
  String message = "Default Hello",
  bool urgent = false,
  required String sender,
}) {
  print('From: $sender -> To: $recipient | Msg: $message | Urgent: $urgent');
}

void sendNotificationPositional(
  String recipient, [
  String message = "Default Hello",
  bool urgent = false,
]) {
  print('To: $recipient | Msg: $message | Urgent: $urgent');
}

List<int> customMap(List<int> list, int Function(int) action) {
  List<int> result = [];
  for (var item in list) {
    result.add(action(item));
  }
  return result;
}

Function createCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

void main() {
  var config = APIConfig(endpoint: "https://api.example.com/v1", enableLogs: true);
  print('APIConfig: ${config.endpoint}, Timeout: ${config.timeoutSeconds}s, Logs: ${config.enableLogs}');

  sendNotification("Bob", sender: "Alice", message: "Meeting at 3 PM", urgent: true);
  sendNotification("Charlie", sender: "System");
  sendNotificationPositional("David", "Urgent Alert", true);

  var numbers = [1, 2, 3, 4, 5];
  var squared = customMap(numbers, (x) => x * x);
  print('Custom mapped squares: $squared');

  var counterA = createCounter();
  var counterB = createCounter();

  print('counterA call 1: ${counterA()}');
  print('counterA call 2: ${counterA()}');
  print('counterB call 1: ${counterB()}');
  print('counterA call 3: ${counterA()}');
}
