import 'dart:io';

import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/user_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:cloud_billr/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _websiteController = TextEditingController();

  File? selectedImage;
  final _formKey = GlobalKey<FormState>();

  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phone = value.trim();

    // Remove spaces, + and -
    final cleanedPhone = phone.replaceAll(' ', '').replaceAll('-', '');

    if (cleanedPhone.startsWith('+')) {
      if (cleanedPhone.length < 10 || cleanedPhone.length > 15) {
        return 'Enter a valid phone number';
      }
    } else {
      if (cleanedPhone.length < 7 || cleanedPhone.length > 15) {
        return 'Enter a valid phone number';
      }
    }

    return null;
  }

  String? websiteValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Website is optional
    }

    final website = value.trim().toLowerCase();

    if (!website.startsWith('http://') &&
        !website.startsWith('https://') &&
        !website.startsWith('www.')) {
      return 'Enter a valid website URL';
    }

    return null;
  }

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

  UserModel onSave(){
    final name = _nameController.text.trim();
    final title = _titleController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final company = _companyController.text.trim();
    final website = _websiteController.text.trim();

    final result = UserModel(
      id: UniqueKey().toString(), 
      name: name, 
      email: email, 
      phone: phone, 
      companyName: company, 
      websiteLink: website,
      title: title
    );

    return result;
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
          child: Form(
            key: _formKey,
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
                  validator: (value) => requiredValidator(value, 'Name'),
                ),
                SizedBox(height: AppSpacing.spacingM),
                LabeledTextField(
                  label: 'Professional Title',
                  hintText: 'e.g., Freelance Designer',
                  controller: _titleController,
                  validator: (value) => requiredValidator(value, 'Title'),
                ),
                SizedBox(height: AppSpacing.spacingM),
                LabeledTextField(
                  label: 'Email Address',
                  hintText: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: emailValidator,
                ),
                SizedBox(height: AppSpacing.spacingM),
                LabeledTextField(
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: phoneValidator,
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
                  validator: (value) => requiredValidator(value, 'Company name'),
                  
                ),
                SizedBox(height: AppSpacing.spacingM),
                LabeledTextField(
                  label: 'Website',
                  hintText: 'Enter website URL',
                  keyboardType: TextInputType.url,
                  controller: _websiteController,
                  validator: websiteValidator,
                ),
                SizedBox(height: AppSpacing.spacingXL),
            
                // Save Button
                AppButton(
                  buttonLabel: 'Save Changes', 
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      final result = onSave();

                      // Provider.of<UserPr
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                ),
                SizedBox(height: AppSpacing.spacingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
