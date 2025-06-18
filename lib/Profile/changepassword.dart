import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madadgaar/utils/api_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false; // State variable to track loading state

  final apiController = ApiController();

  Future<void> _changePassword() async {
    // 1. Check if the form is valid first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Set loading state to true to disable the button and show an indicator
    setState(() {
      _isLoading = true;
    });

    try {
      final oldPassword = oldPasswordController.text;
      final newPassword = newPasswordController.text;

      final headers = await apiController.getAuthHeaders();
      final response = await http.patch(
        Uri.parse('${apiController.baseUrl}/auth/changePassword'),
        headers: {
          ...headers,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      // After the await, check if the widget is still in the tree.
      if (!mounted) return;

      // Handle the response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Old password is incorrect')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to change password: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      // 3. IMPORTANT: Set loading state to false in the finally block
      // This ensures the UI is re-enabled even if an error occurs.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Old Password
              TextFormField(
                controller: oldPasswordController,
                obscureText: _obscureOld,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOld ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter your old password';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // New Password
              TextFormField(
                controller: newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                // 4. Use the _isLoading flag to disable the button
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
