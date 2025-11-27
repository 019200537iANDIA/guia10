import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  String password = '';
  bool loading = false;

  // Login con email y contraseña
  Future<void> _loginWithEmail() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() => loading = true);

      final user = await _authService.signInWithEmail(email, password);

      setState(() => loading = false);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    }
  }

  // Login con Google
  Future<void> _loginWithGoogle() async {
    setState(() => loading = true);

    final user = await _authService.signInWithGoogle();

    setState(() => loading = false);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                child:
                    Icon(Icons.medical_services, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'First Aid App',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text('Primeros auxilios al alcance de todos'),
              const SizedBox(height: 30),

              // Formulario de login
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (v) => email = v!.trim(),
                      validator: (v) => v != null && v.contains('@')
                          ? null
                          : 'Email inválido',
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onSaved: (v) => password = v!.trim(),
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : 'Mínimo 6 caracteres',
                    ),
                    const SizedBox(height: 20),

                    // Botón de login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : _loginWithEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Iniciar Sesión',
                                style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Divisor
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('O continuar con'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Botón de Google
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: loading ? null : _loginWithGoogle,
                        icon: Image.network(
                          'https://www.google.com/favicon.ico',
                          height: 24,
                        ),
                        label: const Text('Iniciar con Google'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Enlace a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta? '),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/signup'),
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
