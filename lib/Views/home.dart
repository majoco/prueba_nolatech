import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/Authentication/login.dart';
import 'package:flutter_nolatech2/Authentication/signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  get darkBlue => null;

  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/fondo.png"), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          //We put all our textfield to a form to be controlled and not allow as empty
          child: Form(
            key: formKey,
            child: Column(
              children: [
                //Username field

                //Before we show the image, after we copied the image we need to define the location in pubspec.yaml
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
                  child: Image.asset(
                    "lib/assets/LOGO.png",
                    width: 210,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.50),

                //Login button
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xF0AAF724)),
                  //#AAF724
                  child: TextButton(
                    onPressed: () {
                      //Navigate to sign up
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Iniciar sessión",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),

                const SizedBox(height: 20),

                //Sign up button
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(125, 125, 126, 0.5),
                  ),
                  child: TextButton(
                      onPressed: () {
                        //Navigate to sign up
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text("Registrarme",
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
