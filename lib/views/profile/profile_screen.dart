import 'dart:io';

import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'johndoe@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 019-2834');
  final _titleController = TextEditingController(text: 'Freelance UI/UX Designer');
  final _companyController = TextEditingController(text: 'Doe Design Studio');
  final _websiteController = TextEditingController(text: 'www.doedesign.studio');

  File? selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
  
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
  
    if (image != null) {
      setState(() {
        // Store/use the image here
        selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: appColors.redColor,),
                title: Text('Remove Photo', style: TextStyle(color: appColors.redColor,)),
                onTap: () {
                  setState(() {
                    selectedImage = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: appColors.secondaryColor,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : null,
                          child: selectedImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: appColors.textColor,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showImageSourceDialog(context);
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: appColors.primaryColor,
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.spacingM),
                    Text(
                      _nameController.text,
                      style: TextStyle(
                        color: appColors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _titleController.text,
                      style: TextStyle(
                        color: appColors.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.spacingXL),

              // Personal Information Section
              Text(
                'Personal Information',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Professional Title',
                hintText: 'e.g., Freelance Designer',
                controller: _titleController,
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Email Address',
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Phone Number',
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              SizedBox(height: AppSpacing.spacingXL),

              // Business Details Section
              Text(
                'Business Details',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Company Name',
                hintText: 'Enter company name',
                controller: _companyController,
              ),
              SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Website',
                hintText: 'Enter website URL',
                keyboardType: TextInputType.url,
                controller: _websiteController,
              ),
              SizedBox(height: AppSpacing.spacingXL),

              // Save Button
              SizedBox(
                width: double.infinity,
                // height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Simulating a profile update
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
