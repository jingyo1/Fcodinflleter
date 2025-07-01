import '../controllers/UserController.dart';
import '../utils/User_class.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final UserController userController;
  const LoginScreen({super.key, required this.userController});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isLoading = false;
  Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  try {
    await widget.userController.login(
      userid: _idController.text.trim(),
      password: _pwController.text,
    );

    // 로그인 성공 시
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: '아이디'),
                validator: (value) => value == null || value.isEmpty ? '아이디를 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pwController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? '비밀번호를 입력하세요' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('로그인'),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(
                        userController: widget.userController,
                      ),
                    ),
                  ).then((value) {
                    if (value is UserInfo) {
                      Navigator.pop(context, true);
                    }
                  });
                },
                child: Text('회원가입'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('취소'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final UserController userController;
  const RegisterScreen({Key? key, required this.userController}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isLoading = true);
  try {
    await widget.userController.register(
      id: _idController.text.trim(),
      nickname: _nicknameController.text.trim(),
      password: _passwordController.text,
    );

    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  void dispose() {
    _idController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(labelText: '아이디'),
                        validator: (value) => value!.isEmpty ? '아이디를 입력하세요' : null,
                      ),
                      TextFormField(
                        controller: _nicknameController,
                        decoration: InputDecoration(labelText: '닉네임'),
                        validator: (value) => value!.isEmpty ? '닉네임을 입력하세요' : null,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: '비밀번호'),
                        validator: (value) => value!.length < 8 ? '8자 이상 입력하세요' : null,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: '비밀번호 확인'),
                        validator: (value) => value != _passwordController.text ? '비밀번호가 일치하지 않습니다' : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _register, child: Text('가입하기')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('취소'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
