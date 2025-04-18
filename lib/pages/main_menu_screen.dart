import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../pages/auth_pages.dart';
import '../services/auth_provider.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    FeedPage(),
    SearchPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    if (!isLoggedIn) {
      return const LandingPage();
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: S.of(context).search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: S.of(context).notifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: S.of(context).profile,
          ),
        ],
      ),
    );
  }
}

// Placeholder pages for each tab
class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).home));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).search));
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).notifications));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).profile));
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Locale? _selectedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLocale ??= Localizations.localeOf(context);
  }

  void _changeLanguage(Locale? locale) {
    if (locale == null) return;
    setState(() {
      _selectedLocale = locale;
    });
    S.load(locale);
  }

 @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final supportedLocales = S.delegate.supportedLocales;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(loc.register),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(loc.login),
             ),            
             DropdownButton<Locale>(
              value: _selectedLocale,
              onChanged: _changeLanguage,
              items: supportedLocales.map((locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(locale.languageCode == 'en' ? 'English' : 'Italiano'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
