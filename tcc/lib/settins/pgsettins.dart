import 'package:flutter/material.dart';
import 'package:tcc/main.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';
import 'package:tcc/settins/editarperfil.dart';
import 'package:tcc/settins/segurancap.dart';

class settinspage extends StatefulWidget {
  const settinspage({super.key});

  @override
  State<settinspage> createState() => _settinspageState();
}

class _settinspageState extends State<settinspage> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeigth => MediaQuery.of(context).size.height;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Configurações",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Conta'),
                  subtitle: Text('Gerenciar sua conta'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Editar_Perfil()),
                      ),
                ),
            
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Acesso e segurança'),
                  subtitle: Text('Configurações de segurança'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Seguranca()),
                      ),
                ),
            
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre'),
                  subtitle: Text('Informações sobre o aplicativo'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
            
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Central de ajuda'),
                  subtitle: Text('Obtenha suporte e ajuda'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Ação ao clicar na opção
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Termos de serviço'),
                  subtitle: Text('Leia os termos de uso'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Ação ao clicar na opção
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Política de privacidade'),
                  subtitle: Text('Saiba mais sobre nossa política'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Ação ao clicar na opção
                  },
                ),
            
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Contrato do Usuário'),
                  subtitle: Text('Leia o contrato do usuário'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Ação ao clicar na opção
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
                        MaterialPageRoute(builder: (context) => Main()),
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
        ),
      ),
    );
  }
}
