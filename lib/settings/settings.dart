import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _backendAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBackendAddress();
  }

  Future<void> _loadBackendAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final backendAddress =
        prefs.getString('backend_addr') ?? '192.168.100.51:4000';
    setState(() {
      _backendAddressController.text = backendAddress;
    });
  }

  Future<void> _saveBackendAddress(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backend_addr', _backendAddressController.text);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backend address saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _backendAddressController,
                decoration: const InputDecoration(
                  labelText: 'Backend Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveBackendAddress(context),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
