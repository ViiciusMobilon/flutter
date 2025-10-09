
import 'package:flutter/material.dart';
import 'package:tcc/esqueci_a_senha/esqueciasenha.dart';
import 'package:tcc/settins/seguranca/email.dart';

class Seguranca extends StatefulWidget {
  const Seguranca({super.key});

  @override
  State<Seguranca> createState() => _SegurancaState();
}

class _SegurancaState extends State<Seguranca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Segurança",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",
          ),
        ),
        backgroundColor: const Color(0xFFFEF7FD),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lock, color: Colors.indigoAccent),
            title: Text(
              'Alterar Email',
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrocarEmail()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.indigoAccent),
            title: Text(
              'Alterar numero',
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrocarEmail()),
            ),
          ),
          CamposSenha(),
        ],
      ),
    );
  }
}

class CamposSenha extends StatefulWidget {
  const CamposSenha({super.key});

  @override
  State<CamposSenha> createState() => _CamposSenhaState();
}

class _CamposSenhaState extends State<CamposSenha> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _salvarSenha() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode colocar a lógica de salvar a senha
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha alterada com sucesso!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.08,
        right: screenWidth * 0.08,
        top: screenHeight * 0.05,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Senha Atual
            Text(
              'Senha Atual',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              controller: _senhaAtualController,
              obscureText: _obscureSenhaAtual,
              decoration: InputDecoration(
                hintText: 'Digite sua senha atual',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureSenhaAtual ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureSenhaAtual = !_obscureSenhaAtual;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Digite a senha atual";
                return null;
              },
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Esqueciasenha()),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigoAccent,
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontFamily: "Poppins",
                ),
              ),
              child: const Text("Esqueci minha senha"),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Nova Senha
            Text(
              'Nova Senha',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              controller: _novaSenhaController,
              obscureText: _obscureNovaSenha,
              decoration: InputDecoration(
                hintText: 'Digite sua nova senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNovaSenha ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNovaSenha = !_obscureNovaSenha;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Digite a nova senha";
                if (value.length < 6) return "Senha deve ter ao menos 6 caracteres";
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.03),

            // Confirmar Nova Senha
            Text(
              'Confirmar Nova Senha',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              controller: _confirmarSenhaController,
              obscureText: _obscureConfirmarSenha,
              decoration: InputDecoration(
                hintText: 'Confirme sua nova senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmarSenha = !_obscureConfirmarSenha;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Confirme a senha";
                if (value != _novaSenhaController.text) return "As senhas não coincidem";
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.05),

            // Botão Salvar
            Center(
              child: GestureDetector(
                onTap: _salvarSenha,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.indigoAccent],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
