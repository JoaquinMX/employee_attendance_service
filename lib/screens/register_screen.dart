import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: screenHeight / 4,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70)
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "The Company",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Employee Email ID"),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  controller: _emailcontroller,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
