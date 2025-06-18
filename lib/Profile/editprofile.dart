import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madadgaar/utils/api_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EditProfile extends StatefulWidget {
  final Function(String)? onImageChanged;  // callback for image path

  const EditProfile({super.key, this.onImageChanged});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  final picker = ImagePicker();

  bool isEditing = false;

  String name = "Hafiz Abdul Samad";
  String email = "samadali1671@gmail.com";
  String phoneNo = "";
  String dateOfBirth = "";
  String firstName = "";
  String lastName = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _hasChanged = false;
  File? _originalImage;
  final apiController = ApiController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFirstName = sharedPreferences.getString('userFirstName');
    final userLastName = sharedPreferences.getString('userLastName');
    final userEmail = sharedPreferences.getString('userEmail');
    final userPhone = sharedPreferences.getString('userPhone');
    final userDob = sharedPreferences.getString('userDob');
    final imagePath = sharedPreferences.getString('profileImagePath') ??
        sharedPreferences.getString('profileImage');
    setState(() {
      firstName = userFirstName ?? "";
      lastName = userLastName ?? "";
      name = ('$firstName $lastName').trim();
      email = userEmail ?? email;
      phoneNo = userPhone ?? phoneNo;
      dateOfBirth = userDob ?? dateOfBirth;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      if (imagePath != null &&
          imagePath.isNotEmpty &&
          File(imagePath).existsSync()) {
        image = File(imagePath);
        _originalImage = File(imagePath);
      } else {
        _originalImage = null;
      }
    });
  }

  Future<void> imagePicker({ImageSource? source}) async {
    final pickedfile =
        await picker.pickImage(source: source ?? ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
      });
      if (widget.onImageChanged != null) {
        widget.onImageChanged!(pickedfile.path);
      }
      _checkForChanges();
    }
  }

  void _checkForChanges() {
    setState(() {
      _hasChanged = firstNameController.text != firstName ||
          lastNameController.text != lastName ||
          emailController.text != email ||
          phoneController.text != phoneNo ||
          dobController.text != dateOfBirth ||
          ((image?.path ?? '') != (_originalImage?.path ?? ''));
    });
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      nameController.text = name;
      emailController.text = email;
      phoneController.text = phoneNo;
      dobController.text = dateOfBirth;
      _hasChanged = false;
    });
    firstNameController.addListener(_checkForChanges);
    lastNameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    dobController.addListener(_checkForChanges);
  }

  void _removeChangeListeners() {
    firstNameController.removeListener(_checkForChanges);
    lastNameController.removeListener(_checkForChanges);
    emailController.removeListener(_checkForChanges);
    phoneController.removeListener(_checkForChanges);
    dobController.removeListener(_checkForChanges);
  }

  void saveChanges() async {
    _removeChangeListeners();
    setState(() {
      isEditing = false;
      _hasChanged = false;
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final Map<String, String> fields = {};
    if (firstNameController.text !=
        sharedPreferences.getString('userFirstName')) {
      fields['firstName'] = firstNameController.text;
    }
    if (lastNameController.text !=
        sharedPreferences.getString('userLastName')) {
      fields['lastName'] = lastNameController.text;
    }
    if (phoneController.text != sharedPreferences.getString('userPhone')) {
      fields['phone'] = phoneController.text;
    }
    if (dobController.text != sharedPreferences.getString('userDob')) {
      fields['dateOfBirth'] = dobController.text;
    }
    bool imageChanged =
        (image != null && (image?.path != _originalImage?.path));
    if (fields.isNotEmpty || imageChanged) {
      final request = http.MultipartRequest(
          'PUT', Uri.parse('${apiController.baseUrl}/auth/updateProfile'));
      final headers = await apiController.getAuthHeaders();
      request.headers.addAll(headers);
      fields.forEach((key, value) {
        request.fields[key] = value.isNotEmpty ? value : '';
      });
      if (imageChanged) {
        final mimeType = _lookupMimeType(image!.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            image!.path,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      }
      if (!fields.containsKey('firstName')) request.fields['firstName'] = '';
      if (!fields.containsKey('lastName')) request.fields['lastName'] = '';
      if (!fields.containsKey('phone')) request.fields['phone'] = '';
      if (!fields.containsKey('dateOfBirth')) {
        request.fields['dateOfBirth'] = '';
      }
      if (!imageChanged) {
        request.fields['profilePicture'] = '';
      }
      debugPrint('API REQUEST URL: \\${request.url}');
      debugPrint('API REQUEST FIELDS: \\${request.fields}');
      debugPrint(
          'API REQUEST FILES: \\${request.files.map((f) => f.filename).toList()}');
      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        debugPrint('API RESPONSE STATUS: \\${response.statusCode}');
        debugPrint('API RESPONSE BODY: \\${response.body}');
        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Only update local state and preferences if API succeeds
          setState(() {
            firstName = firstNameController.text;
            lastName = lastNameController.text;
            name = ('$firstName $lastName').trim();
            email = emailController.text;
            phoneNo = phoneController.text;
            dateOfBirth = dobController.text;
            _originalImage = image;
          });
          await sharedPreferences.setString('userFirstName', firstName);
          await sharedPreferences.setString('userLastName', lastName);
          await sharedPreferences.setString('userName', name);
          await sharedPreferences.setString('userEmail', email);
          await sharedPreferences.setString('userPhone', phoneNo);
          await sharedPreferences.setString('userDob', dateOfBirth);
          if (image != null) {
            await sharedPreferences.setString('profileImagePath', image!.path);
          }
        } else {
          // Optionally show error to user
        }
      } catch (e) {
        // Optionally show error to user
      }
    }
  }

  String _formatDateForDisplay(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isEditing,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && isEditing) {
          setState(() {
            isEditing = false;
            // Discard all edits by resetting controllers and image
            firstNameController.text = firstName;
            lastNameController.text = lastName;
            nameController.text = name;
            emailController.text = email;
            phoneController.text = phoneNo;
            dobController.text = dateOfBirth;
            image = _originalImage;
            _hasChanged = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 60),
                          ),
                  ),
                  if (isEditing)
                    GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      await imagePicker(
                                          source: ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Camera'),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      await imagePicker(
                                          source: ImageSource.camera);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Show either info or editable fields
              isEditing
                  ? Column(
                      children: [
                        TextField(
                          controller: firstNameController,
                          decoration:
                              const InputDecoration(labelText: "First Name"),
                        ),
                        TextField(
                          controller: lastNameController,
                          decoration:
                              const InputDecoration(labelText: "Last Name"),
                        ),
                        TextField(
                          controller: phoneController,
                          decoration:
                              const InputDecoration(labelText: "Phone No"),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(dobController.text) ??
                                      DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              locale: const Locale(
                                  'en', 'GB'), // Forces dd/MM/yyyy format
                            );
                            if (picked != null) {
                              dobController.text = picked.toIso8601String();
                              setState(() {}); // To update display
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(
                                  text: _formatDateForDisplay(
                                      dobController.text)),
                              decoration: const InputDecoration(
                                  labelText: "Date of Birth"),
                              readOnly: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save"),
                          onPressed: _hasChanged ? saveChanges : null,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InfoRow(label: "Name", value: name),
                        InfoRow(label: "Email", value: email),
                        InfoRow(label: "Phone", value: phoneNo),
                        InfoRow(
                          label: "DOB",
                          value: dateOfBirth.isNotEmpty
                              ? DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(dateOfBirth))
                              : "N/A",
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                          onPressed: startEditing,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.isNotEmpty ? value : "N/A")),
        ],
      ),
    );
  }
}

String? _lookupMimeType(String path) {
  final extension = path.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'bmp':
      return 'image/bmp';
    case 'webp':
      return 'image/webp';
    default:
      return null;
  }
}
