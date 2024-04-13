import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logintest/components/my_button.dart';
import 'package:logintest/components/my_textfield.dart';
import 'package:logintest/components/square_tile.dart';
import 'login_or_register_page.dart';
import 'package:logintest/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
// text editing controllers
class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
  }

  // sign creating the user
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign up
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // add user details
        addUserDetails(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          int.parse(ageController.text.trim()),
        );
      } else {
        // show error message, passwords don't match'
        showErrorMessage("Passwords don't match");
      }

      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  Future addUserDetails(String firstName, String lastName, String email, int age ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    });
  }

  // wrong message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            //    const SizedBox(height: 25),

            // logo
            //const Icon(
            //  Icons.lock,
            //  size: 50,
            //),

            const SizedBox(height: 25),

            // let's create an account for you!
            Text(
              'Let\'s create an account for you!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: ageController,
              hintText: 'Age',
              obscureText: false,
            ),

            const SizedBox(height: 25),

            // sign in button
            MyButton(
              text: "Sign Up",
              onTap: signUserUp,
            ),

            const SizedBox(height: 50),

            // or continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // google + apple sign in buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google button
                SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/google.png'
                ),

                SizedBox(width: 25),

                // apple button
                SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/apple.png')
              ],
            ),

            const SizedBox(height: 25),

            // not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              'Already have an account?',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text(
                'Login now',
                style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ],
        ),
        ],
      ),
    ),
    ),
    ),
    );
  }
}
