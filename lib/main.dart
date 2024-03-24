import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:fugaz_movil/SecondPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fugaz Retro",
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color.fromARGB(106, 172, 169, 169)),
        colorScheme: ColorScheme.light()
      ),
      home: const MyHomePage(title: 'Fugaz Retro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.network(
                  "https://cdn-3.expansion.mx/dims4/default/5339ade/2147483647/strip/true/crop/8409x5945+0+0/resize/1200x848!/format/webp/quality/60/?url=https%3A%2F%2Fcdn-3.expansion.mx%2Fd8%2F15%2F97756b4a444287dbf850dee43121%2Fistock-1292443598.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller:
                    _emailController, // Aquí se asigna el controlador al campo de correo
                decoration: InputDecoration(
                  hintText: 'Correo',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                  fillColor: Color.fromARGB(255, 182, 180, 180),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  if (value!.isEmpty) {
                    return "El correo es necesario";
                  } else if (!regExp.hasMatch(value)) {
                    return "Correo inválido";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                  fillColor: Color.fromARGB(255, 182, 180, 180),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  String pattern =
                      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$';
                  RegExp regExp = RegExp(pattern);
                  if (value!.isEmpty) {
                    return "La contraseña es necesaria";
                  } else if (value.length < 6 || value.length >= 20) {
                    return 'La contraseña debe tener 10 caracteres o más';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(90.0, 20.0, 90.0, 0.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 107, 32, 32),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String email = _emailController.text;
                    final String password = _password;

                    // Aquí debes realizar la solicitud a tu API para verificar los datos
                    final apiUrl =
                        'https://apibackend-0m1w.onrender.com/api/user';
                    final response = await http.get(Uri.parse(apiUrl));

                    if (response.statusCode == 200) {
                      final List<dynamic> users = json.decode(response.body);

                      bool found = false;
                      for (var user in users) {
                        if (user['correo'] == email &&
                            user['contraseña'] == password) {
                          found = true;
                          break;
                        }
                      }

                      if (found) {
                        // Si los datos son válidos, redirige a la página de pedidos
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const pedidos(),
                          ),
                        );
                      } else {
                        // Si los datos no son válidos, muestra un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Usuario o Contraseña incorrectos')),
                        );
                      }
                    } else {
                      // Manejar el error si la solicitud falla
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al cargar los usuarios')),
                      );
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 107, 32, 32),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecuperarContrasena(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Recuperar contraseña",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({Key? key}) : super(key: key);

  @override
  _RecuperarContrasenaState createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailValido = true;

  void _enviarCodigo(BuildContext context) async {
    String email = _emailController.text;

    if (_validarEmail(email)) {
      // Dirección de correo electrónico del remitente
      final String remitente =
          'mazocaro14@gmail.com'; // Cambia por tu dirección de correo electrónico

      // Configuración del servidor SMTP de Gmail
      final smtpServer = gmail(remitente, 'tu_contraseña');

      // Creación del mensaje de correo electrónico
      final message = Message()
        ..from = Address(remitente, 'Tu Nombre') // Remitente
        ..recipients.add(email) // Destinatario
        ..subject = 'Recuperación de contraseña'
        ..text =
            'Aquí va tu código de recuperación'; // Mensaje de correo electrónico con el código de recuperación

      try {
        // Envío del correo electrónico
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        // Mostrar un mensaje de éxito o realizar alguna acción adicional

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Se ha enviado un código al correo electrónico proporcionado.')),
        );
      } catch (e) {
        print('Error al enviar el correo electrónico: $e');
        // Manejar el error, mostrar un mensaje de error, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al enviar el correo electrónico. Por favor, intenta nuevamente.')),
        );
      }
    }
  }

  bool _validarEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _emailValido = false;
      });
      return false;
    }
    return true;
  }

  String _generarCodigo() {
    // Generar un código aleatorio de 6 dígitos
    final random = Random();
    String codigo = '';
    for (int i = 0; i < 6; i++) {
      codigo += random.nextInt(10).toString();
    }
    return codigo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                errorText: _emailValido ? null : 'Correo electrónico no válido',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _enviarCodigo(context),
              child: Text('Enviar código'),
            ),
          ],
        ),
      ),
    );
  }
}
