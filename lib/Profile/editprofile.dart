import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String phoneNo = "+923074167360";
  String dateOfBirth = "2001/04/06";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  Future<void> imagePicker() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
      });
      // Call callback to send new image path immediately
      if (widget.onImageChanged != null) {
        widget.onImageChanged!(pickedfile.path);
      }
    }
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      nameController.text = name;
      emailController.text = email;
      phoneController.text = phoneNo;
      dobController.text = dateOfBirth;
    });
  }

  void saveChanges() {
    setState(() {
      isEditing = false;
      name = nameController.text;
      email = emailController.text;
      phoneNo = phoneController.text;
      dateOfBirth = dobController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      : Image.asset(
                    "assets/my_image.jpg",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: imagePicker,
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
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone No"),
                ),
                TextField(
                  controller: dobController,
                  decoration:
                  const InputDecoration(labelText: "Date of Birth"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  onPressed: saveChanges,
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfoRow(label: "Name", value: name),
                InfoRow(label: "Email", value: email),
                InfoRow(label: "Phone", value: phoneNo),
                InfoRow(label: "DOB", value: dateOfBirth),
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
