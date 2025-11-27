import 'package:flutter/material.dart';
import '../utils/input_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulación de login
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      // Aquí iría la lógica real de Firebase Auth
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        key: const Key('login_appbar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o título
              const Text(
                'First Aid App',
                key: Key('app_title'),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Campo de email
              TextFormField(
                key: const Key('email_field'),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: InputValidator.validateEmail,
              ),
              const SizedBox(height: 16),

              // Campo de contraseña
              TextFormField(
                key: const Key('password_field'),
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: InputValidator.validatePassword,
              ),
              const SizedBox(height: 24),

              // Mensaje de error
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  key: const Key('error_message'),
                  style: const TextStyle(color: Colors.red),
                ),

              // Botón de login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Iniciar Sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}