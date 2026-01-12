import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers untuk text field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Untuk loading state
  bool _isLoading = false;
  
  // Untuk error message
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk login dengan Firebase
  Future<void> _loginWithFirebase() async {
    // Validasi input
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Gunakan email format (asumsikan input adalah email)
      final email = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Login dengan Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Jika berhasil, akan otomatis navigate ke HomeScreen via AuthWrapper
      
    } on FirebaseAuthException catch (e) {
      // Handle error dari Firebase
      String errorMessage = 'Login gagal';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'User tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Akun dinonaktifkan';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
      
    } catch (e) {
      // Handle error umum
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk registrasi user baru
  Future<void> _registerNewUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final email = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Buat user baru di Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Tampilkan pesan sukses
      _showSuccessDialog();
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registrasi gagal';
      
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah digunakan';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah (minimal 6 karakter)';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registrasi Berhasil'),
        content: Text('Akun berhasil dibuat! Silakan login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buat Akun Baru'),
        content: Text(
          'Email: ${_usernameController.text}\n\n'
          'Apakah Anda ingin membuat akun baru dengan email ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _registerNewUser();
            },
            child: Text('Buat Akun'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: const Icon(Icons.home),
        title: const Text('Widget Flutter Pertama'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'lib/assets/images/picture1.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Ini adalah Aplikasi Flutter Pertamaku',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Kotak Login
            Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Username/Email Field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  
                  // Password Field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  
                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _loginWithFirebase,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  
                  // Register Button
                  TextButton(
                    onPressed: _isLoading ? null : _showRegisterDialog,
                    child: const Text(
                      'Buat akun baru',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                  
                  // Info Text
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Gunakan format email: example@mail.com\nPassword minimal 6 karakter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            // Test Credentials (untuk development)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    'Untuk testing:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _usernameController.text = 'test@example.com';
                          _passwordController.text = '123456';
                          setState(() {
                            _errorMessage = '';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text('Isi Test 1'),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          _usernameController.text = 'user@demo.com';
                          _passwordController.text = 'password';
                          setState(() {
                            _errorMessage = '';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text('Isi Test 2'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Import Firebase Auth
