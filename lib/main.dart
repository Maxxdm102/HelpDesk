import 'package:flutter/material.dart';
import 'dart:async';

/// Variable global para almacenar el ticket seleccionado
Ticket? selectedTicket;

void main() {
  // Punto de entrada de la aplicación
  runApp(const HelpDeskApp());
}

/// App raíz
class HelpDeskApp extends StatelessWidget {
  const HelpDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpDesk Pro Mini',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}


/// MODELO: Ticket
class Ticket {
  final String title;
  final String description;

  const Ticket(this.title, this.description);
}


/// PANTALLA 1 – HOME / LISTA DE TICKETS
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Dataset fijo de tickets
  final List<Ticket> tickets = const [
    Ticket('Error login', 'Usuario no puede iniciar sesión'),
    Ticket('Pantalla en blanco', 'La app no carga correctamente'),
    Ticket('Bug en pagos', 'Error al procesar tarjeta'),
    Ticket('Lentitud', 'La aplicación va muy lenta'),
    Ticket('Crash Android', 'Cierre inesperado'),
    Ticket('Notificaciones', 'No llegan avisos'),
    Ticket('Perfil', 'No guarda cambios'),
    Ticket('Actualización', 'Fallo tras update'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpDesk - Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegación a Ajustes usando ruta nombrada
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.support_agent),
              title: Text(ticket.title),
              subtitle: Text(ticket.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Guardamos ticket seleccionado en variable global
                selectedTicket = ticket;

                // Navegación a pantalla de detalle
                Navigator.pushNamed(context, '/detail');
              },
            ),
          );
        },
      ),
    );
  }
}


/// PANTALLA 2 – DETALLE DEL TICKET
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int priority = 1;

  // Simula carga de datos 
  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Mostrar SnackBar
  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Ticket')),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          // Mientras carga
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Contenido ya cargado
          return GestureDetector(
            // Doble tap para resetear prioridad
            onDoubleTap: () {
              setState(() => priority = 1);
              showSnack('Prioridad reiniciada');
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedTicket!.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(selectedTicket!.description),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Prioridad', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(
                            '$priority',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() => priority++);
                                  showSnack('Prioridad aumentada');
                                },
                                child: const Text('+'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (priority > 1) {
                                    setState(() => priority--);
                                    showSnack('Prioridad reducida');
                                  }
                                },
                                child: const Text('-'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Doble tap para resetear prioridad',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


/// PANTALLA 3 – AJUSTES
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Modo oscuro'),
              subtitle: Text('Próximamente'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificaciones'),
              subtitle: Text('Activadas'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Versión'),
              subtitle: Text('1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
}
