import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/enums.dart';

class AppConfig {
  static late DataMode dataMode;
  static late String apiBaseUrl;
  static late String appName;
  static bool isFirebaseAvailable = false;

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");

    appName = dotenv.get('APP_NAME', fallback: 'Luxora Stay');
    apiBaseUrl = dotenv.get('API_BASE_URL', fallback: '');

    final modeStr = dotenv.get('APP_DATA_MODE', fallback: 'auto').toLowerCase();
    switch (modeStr) {
      case 'real':
        dataMode = DataMode.real;
        break;
      case 'mock':
        dataMode = DataMode.mock;
        break;
      default:
        dataMode = DataMode.auto;
    }
  }

  static bool get isMock => dataMode == DataMode.mock;
  static bool get isReal => dataMode == DataMode.real;
  static bool get isAuto => dataMode == DataMode.auto;
}
