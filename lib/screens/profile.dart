import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/models/myuser.dart';
import 'package:pasji_cuvaj/providers/database_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  late Future<MyUser?> currentUser;
  String changePasswordMessage = '';
  Color changePasswordMessageColor = Colors.red;
  bool changesApplied = false;

  // Create an instance of DatabaseProvider
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  @override
  void initState() {
    super.initState();
    // Fetch the current user data when the screen is loaded
    currentUser = fetchCurrentUser();
  }

  Future<MyUser?> fetchCurrentUser() async {
    try {
      // Replace 'userEmail' with the actual email of the logged-in user
      String userEmail = FirebaseAuth.instance.currentUser!.email!;
      String? userId =
          await _databaseProvider.getUserIdFromCollection(userEmail);
      if (userId != null) {
        return _databaseProvider.getUserData(userId);
      }
      return null;
    } catch (e) {
      print('Error fetching current user data: $e');
      return null;
    }
  }

  Future<void> updateProfile() async {
    try {
      // Get the updated values from the text controllers
      String newName = nameController.text.trim();
      String newSurname = surnameController.text.trim();
      String newUsername = usernameController.text.trim();

      // Check if any information is updated
      if (newName.isNotEmpty ||
          newSurname.isNotEmpty ||
          newUsername.isNotEmpty) {
        // Use your authentication method to get the current user's email
        String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

        // Get the user ID from the database using the email
        String? userId =
            await _databaseProvider.getUserIdFromCollection(currentUserEmail);

        if (userId != null) {
          // Update the user profile in the database
          await _databaseProvider.updateUserProfile(
              userId, newName, newSurname, newUsername);

          // Show a success message
          print('User profile updated successfully!');

          // Rebuild the widget to display the updated information
          setState(() {
            currentUser = fetchCurrentUser();
            changesApplied = true;
          });
        } else {
          print('User ID not found.');
        }
      } else {
        print('No information to update.');
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> changePassword() async {
    try {
      String currentPassword = currentPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();
      String confirmNewPassword = confirmNewPasswordController.text.trim();

      // Check if any field is empty
      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmNewPassword.isEmpty) {
        setState(() {
          changePasswordMessage = 'Please fill in all fields.';
          changePasswordMessageColor = Colors.red;
        });
        return;
      }

      // Check if new password matches confirmation
      if (newPassword != confirmNewPassword) {
        setState(() {
          changePasswordMessage = 'New passwords do not match.';
          changePasswordMessageColor = Colors.red;
        });
        return;
      }

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Reauthenticate the user with their current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (reauthError) {
        setState(() {
          changePasswordMessage = 'Incorrect current password.';
          changePasswordMessageColor = Colors.red;
        });
        return;
      }

      // Update the user's password
      await user.updatePassword(newPassword);

      setState(() {
        changePasswordMessage = 'Password changed successfully!';
        changePasswordMessageColor = Colors.green;
      });

      print('Password changed successfully!');
    } catch (e) {
      setState(() {
        changePasswordMessage = 'Error changing password: $e';
        changePasswordMessageColor = Colors.red;
      });
      print('Error changing password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<MyUser?>(
          future: currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return Text('No user data found.');
            } else {
              // Populate the text controllers with the fetched user data
              MyUser user = snapshot.data!;
              nameController.text = user.name;
              surnameController.text = user.surname;
              usernameController.text = user.username;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: InputDecoration(labelText: 'Surname'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: Text('Update Profile'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    changesApplied
                        ? 'Changes applied successfully!'
                        : '', // Display only when changes are applied
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Change Password:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: confirmNewPasswordController,
                    decoration:
                        InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: changePassword,
                    child: Text('Change Password'),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    changePasswordMessage,
                    style: TextStyle(
                      color: changePasswordMessageColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
