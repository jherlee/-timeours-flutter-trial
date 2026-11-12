import 'package:flutter/material.dart';

// TimeOurs 登入頁 Flutter 試跑版
// 設計依據：2026-11-06/07 自 timeours.com 實站 HTML/CSS 驗證的登入頁規格
//   - 置中單欄約 301px；標題「登入 TimeOurs」20px
//   - OAuth 按鈕品牌色：Facebook #334C7E、Google #C93B24、X 黑色
//   - 輸入框無 label、只有 placeholder；錯誤訊息色 #FF6B7D
//   - 註冊：帳號／信箱／密碼／確認密碼 4 欄＋條款句
//   - 驗證：帳號 6–50 字元、密碼 ≥8 字元、兩次密碼一致；登入僅檢查非空
//   - 預設深藍灰主題：背景 #1C2134、卡片 #262E46、主色 #E64C65（Figma primary）
// 注意：本試跑版是 demo UI，未串接任何後端；按下登入／註冊只做格式驗證並提示。

void main() => runApp(const TimeOursApp());

class TimeOursApp extends StatelessWidget {
  const TimeOursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeOurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C2134),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE64C65),
          surface: Color(0xFF262E46),
        ),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegister = false;
  final _account = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _account.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final account = _account.text.trim();
    final password = _password.text;
    setState(() => _error = null);

    if (_isRegister) {
      final email = _email.text.trim();
      if (account.length < 6 || account.length > 50) {
        setState(() => _error = '帳號需為 6–50 字元');
        return;
      }
      if (!email.contains('@')) {
        setState(() => _error = '請輸入有效的信箱');
        return;
      }
      if (password.length < 8) {
        setState(() => _error = '密碼需至少 8 字元');
        return;
      }
      if (password != _confirm.text) {
        setState(() => _error = '兩次輸入的密碼不一致');
        return;
      }
    } else {
      if (account.isEmpty || password.isEmpty) {
        setState(() => _error = '請輸入帳號與密碼');
        return;
      }
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('試跑版'),
        content: const Text('尚未串接後端，這次試跑只驗證畫面與 Runner 建置流程。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _oauth(String provider) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('用 $provider 帳號登入'),
        content: const Text('試跑版未串接 OAuth，僅展示按鈕樣式。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  Widget _oauthButton({
    required String label,
    required String mark,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mark,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF303A58),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SizedBox(
            width: 301,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE64C65),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'T',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '登入 TimeOurs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _oauthButton(
                  label: '用 Facebook 帳號登入',
                  mark: 'f',
                  color: const Color(0xFF334C7E),
                  onPressed: () => _oauth('Facebook'),
                ),
                const SizedBox(height: 12),
                _oauthButton(
                  label: '用 Google 帳號登入',
                  mark: 'G',
                  color: const Color(0xFFC93B24),
                  onPressed: () => _oauth('Google'),
                ),
                const SizedBox(height: 12),
                _oauthButton(
                  label: '用 X 帳號登入',
                  mark: 'X',
                  color: Colors.black,
                  onPressed: () => _oauth('X'),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('或', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                _input(controller: _account, hint: '帳號或信箱'),
                const SizedBox(height: 12),
                if (_isRegister) ...[
                  _input(controller: _email, hint: '信箱'),
                  const SizedBox(height: 12),
                ],
                _input(controller: _password, hint: '密碼', obscure: true),
                if (_isRegister) ...[
                  const SizedBox(height: 12),
                  _input(controller: _confirm, hint: '確認密碼', obscure: true),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(color: Color(0xFFFF6B7D)),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE64C65),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isRegister ? '註冊' : '登入',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegister = !_isRegister;
                      _error = null;
                    });
                  },
                  child: Text(
                    _isRegister ? '已有帳號？回登入頁' : '還沒有帳號？註冊',
                    style: const TextStyle(color: Color(0xFF5C7CFA)),
                  ),
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '註冊即表示同意 TimeOurs 服務條款與隱私權政策',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
