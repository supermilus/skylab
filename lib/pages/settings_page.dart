import 'package:flutter/material.dart';
import '../services/atproto_auth_service.dart';
import '../services/filebase_service.dart';
import '../generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _deleteAccount() async {
    final identifier = await _getIdentifier();
    final password = await _getPassword();
    if (identifier == null || password == null) return;

    final authService = AtprotoAuthService();
    final filebaseService = FilebaseService();
    final userId = identifier;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authDeleted = await authService.deleteAccount(identifier, password);
    final filesDeleted = await filebaseService.deleteAllUserFiles(userId);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (authDeleted && filesDeleted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).accountDeletedSuccessfully)),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToDeleteAccount)),
      );
    }
  }

  Future<String?> _getIdentifier() async {
    String? value;
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(S.of(dialogContext).confirmAtHandle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: S.of(dialogContext).atHandle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(dialogContext).cancel),
            ),
            TextButton(
              onPressed: () {
                value = controller.text.trim();
                Navigator.pop(dialogContext);
              },
              child: Text(S.of(dialogContext).ok),
            ),
          ],
        );
      },
    );
    return value;
  }

  Future<String?> _getPassword() async {
    String? value;
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(S.of(dialogContext).confirmPassword),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: S.of(dialogContext).password),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(dialogContext).cancel),
            ),
            TextButton(
              onPressed: () {
                value = controller.text;
                Navigator.pop(dialogContext);
              },
              child: Text(S.of(dialogContext).ok),
            ),
          ],
        );
      },
    );
    return value;
  }

  void _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(dialogContext).deleteAccount),
        content: Text(S.of(dialogContext).deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(dialogContext).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(S.of(dialogContext).delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _deleteAccount();
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
            onTap: _confirmDeleteAccount,
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
