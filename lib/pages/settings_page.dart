import 'package:flutter/material.dart';
import '../services/atproto_auth_service.dart';
import '../services/filebase_service.dart';
import '../generated/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final identifier = await _getIdentifier(context);
    final password = await _getPassword(context);
    if (identifier == null || password == null) return;

    final authService = AtprotoAuthService();
    final filebaseService = FilebaseService();
    final userId = identifier;

    final deleting = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authDeleted = await authService.deleteAccount(identifier, password);
    final filesDeleted = await filebaseService.deleteAllUserFiles(userId);

    Navigator.of(context).pop();

    if (authDeleted && filesDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).accountDeletedSuccessfully)),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToDeleteAccount)),
      );
    }
  }

  Future<String?> _getIdentifier(BuildContext context) async {
    String? value;
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(S.of(context).confirmAtHandle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: S.of(context).atHandle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                value = controller.text.trim();
                Navigator.pop(context);
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
    return value;
  }

  Future<String?> _getPassword(BuildContext context) async {
    String? value;
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(S.of(context).confirmPassword),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: S.of(context).password),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                value = controller.text;
                Navigator.pop(context);
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
    return value;
  }

  void _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteAccount),
        content: Text(S.of(context).deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _deleteAccount(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(S.of(context).account),
            subtitle: Text(S.of(context).manageAccountSettings),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(S.of(context).deleteAccount, style: const TextStyle(color: Colors.red)),
            onTap: () => _confirmDeleteAccount(context),
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).about),
            subtitle: Text(S.of(context).aboutSkylab),
          ),
          ListTile(
            title: Text(S.of(context).version),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
