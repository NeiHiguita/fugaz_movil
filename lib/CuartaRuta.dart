import 'package:flutter/material.dart';
import 'package:fugaz_movil/TerceraRuta.dart';
import 'package:fugaz_movil/main.dart';
import 'SecondPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'TerceraRuta.dart';

import 'package:flutter/material.dart';

class perfil extends StatefulWidget {
  const perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<perfil> {

void _PresentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

    });
  }
  List<dynamic> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
  }

  Future<void> _fetchPedidos() async {
    final apiUrl = 'https://apibackend-0m1w.onrender.com/api/user'; // Cambia por tu URL de la API

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        _pedidos = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fugaz Retro'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Mi perfil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                final pedido = _pedidos[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre: ${pedido['nombre']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Contraseña: ${pedido['contraseña']}'),
                          Text('Correo: ${pedido['correo']}'),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 107, 32, 32),
              ),
              child: Text(
                'Menu Fugaz Retro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text('Mi Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const perfil(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.move_to_inbox),
              title: Text('Mis pedidos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const pedidos()));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historial de compra'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Historial(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.backspace),
              title: Text('Salir'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
class EditarPerfil extends StatelessWidget {
  final String nombre;
  final String correo;
  final Function(String, String) onGuardar;

  const EditarPerfil({
    Key? key,
    required this.nombre,
    required this.correo,
    required this.onGuardar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nombreController =
        TextEditingController(text: nombre);
    TextEditingController correoController =
        TextEditingController(text: correo);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: correoController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onGuardar(nombreController.text, correoController.text);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
