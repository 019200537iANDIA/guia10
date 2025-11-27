import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  String name = '', email = '', phone = '', password = '';
  bool loading = false;

  Future<void> _register() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() => loading = true);
      
      final user = await _authService.signUpWithEmail(email, password, name, phone);
      
      setState(() => loading = false);
      
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear cuenta. El email puede estar en uso.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  'Regístrate',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => name = v!.trim(),
                  validator: (v) => v != null && v.isNotEmpty 
                      ? null 
                      : 'Nombre requerido',
                ),
                const SizedBox(height: 15),
                
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
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (v) => phone = v!.trim(),
                  validator: (v) => v != null && v.length >= 9 
                      ? null 
                      : 'Teléfono inválido',
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
                const SizedBox(height: 25),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: loading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Registrar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}