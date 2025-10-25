import 'package:flutter/material.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/settins/editarperfil.dart';
import 'package:tcc/settins/seguranca/email.dart';
import 'package:tcc/settins/segurancap.dart';
import 'package:tcc/main.dart'; // caso Main() esteja aqui

class SettinsPage extends StatefulWidget {
  final AuthController authController;

  const SettinsPage({super.key, required this.authController});

  @override
  State<SettinsPage> createState() => _SettinsPageState();
}

class _SettinsPageState extends State<SettinsPage> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FD),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Configurações",
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Conta'),
              subtitle: const Text('Gerenciar sua conta'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Editar_Perfil(authController: widget.authController),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Acesso e segurança'),
              subtitle: const Text('Configurações de segurança'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Seguranca()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              subtitle: const Text('Informações sobre o aplicativo'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrocarEmail()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Central de ajuda'),
              subtitle: const Text('Obtenha suporte e ajuda'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // ação futura
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Termos de serviço'),
              subtitle: const Text('Leia os termos de uso'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // ação futura
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Política de privacidade'),
              subtitle: const Text('Saiba mais sobre nossa política'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // ação futura
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Contrato do Usuário'),
              subtitle: const Text('Leia o contrato do usuário'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // ação futura
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.2,
                vertical: 25,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.red.withOpacity(0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainApp()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 1.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Encerrar sessão",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontFamily: "Poppins",
                      ),
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
