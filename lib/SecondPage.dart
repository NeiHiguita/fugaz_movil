import 'package:flutter/material.dart';
import 'package:fugaz_movil/main.dart';
import 'TerceraRuta.dart';
import 'CuartaRuta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class pedidos extends StatefulWidget {
  const pedidos({Key? key}) : super(key: key);

  @override
  _pedidosState createState() => _pedidosState();
}

class _pedidosState extends State<pedidos> {
  DateTime? _selectedDate;

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
      setState(() {
        _selectedDate = pickedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Selected: ${_selectedDate}'),
        ));
      });
    });
  }

  List<dynamic> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
  }

  Future<void> _fetchPedidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userId') ?? '';

    final apiUrl = 'https://apibackend-0m1w.onrender.com/api/venta';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> allPedidos = json.decode(response.body);
      final List<dynamic> filteredPedidos =
          allPedidos.where((pedido) => pedido['IdUser'] == userId).toList();

      setState(() {
        _pedidos = filteredPedidos;
      });
    } else {
      throw Exception('Error al cargar las compras');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fugaz Retro'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _PresentDatePicker,
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Mis pedidos',
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
                            'Fecha: ${pedido['date_order']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Total: \$${pedido['sale_price']}'),
                          Text('Estado: ${pedido['order_status']}'),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          detalles(pedido: pedido),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Text('Ver Detalles'),
                              ),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const pedidos()));
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

class detalles extends StatelessWidget {
  final dynamic pedido;

  const detalles({Key? key, required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles pedido'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha de Pedido: ${pedido['date_order']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text('Total: \$${pedido['sale_price']}'),
                Text('Estado: ${pedido['order_status']}'),
                SizedBox(height: 20),
                Text(
                  'Detalles del Pedido:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: pedido['detalles_venta'].length,
                  itemBuilder: (context, index) {
                    final detalle = pedido['detalles_venta'][index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Producto: ${detalle['producto']}'),
                        Text('Cantidad: ${detalle['cantidad']}'),
                        Text('Subtotal: \$${detalle['subtotal']}'),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
