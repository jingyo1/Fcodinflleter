import 'package:flutter/material.dart';
import 'screen/Socialscreen.dart';
import 'screen/Settingscreen.dart';
import 'screen/Closetscreen.dart';
import 'screen/Userscreen.dart';
import '../utils/api_client.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  final ApiClient apiClient = ApiClient();


  final GlobalKey<State> _socialKey = GlobalKey<State>();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Scaffold(body: UserScreen(apiClient: apiClient)),
      Scaffold(body: SocialScreen(key: _socialKey, apiClient: apiClient)),
      Scaffold(body: SettingScreen()),
      Scaffold(body: ClosetsScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) {
          if (_currentIndex == 1 && newIndex != 1) {
            final State? state = _socialKey.currentState;
            if (state != null) {
              try {
                (state as dynamic).saveAllPendingLikesToDb();
              } catch (e) {
                debugPrint("saveAllPendingLikesToDb 호출 실패: $e");
              }
            }
          }
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '계정'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '소셜'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: '세팅'),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: '옷장'),
        ],
      ),
    );
  }
}