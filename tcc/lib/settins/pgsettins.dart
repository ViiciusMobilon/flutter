import 'package:flutter/material.dart';
import 'package:tcc/paginas%20principais/pagina_principal.dart';
import 'package:tcc/settins/editarperfil.dart';
import 'package:tcc/settins/seguranca/email/email.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FD),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>TelaPrincipal()),
              );
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
        body: Column(
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
              padding: EdgeInsets.only(top: screenHeigth * 0.08),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 17, 0),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: screenWidth * 0.8,
                height: 50,

                child: Center(
                  child: Text(
                    'Encerrar sessão',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/settins/editarperfil.dart';
import 'package:tcc/settins/seguranca/email.dart';
import 'package:tcc/settins/segurancap.dart';

class settinspage extends StatefulWidget {
    final AuthController authController;

  const settinspage({super.key, required this.authController});

  @override
  State<settinspage> createState() => _settinspageState();
  
}

class _settinspageState extends State<settinspage> {
  double get screenWidth => MediaQuery.of(context).size.width;
   double get screenHeigth => MediaQuery.of(context).size.height;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FD),
           leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        Navigator.of(context).pop();
      },
),
          title:  Text(
            "Configurações",
            style: TextStyle(color: Colors.black,
            fontSize: MediaQuery.of(context).size.width*0.07,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",),
             
          ),
          centerTitle: true,
        ),
        body:Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Conta'),
              subtitle: Text('Gerenciar sua conta'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()=> Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Editar_Perfil(authController: widget.authController,)),)
            ),
         
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acesso e segurança'),
              subtitle: Text('Configurações de segurança'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap:  ()=> Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Seguranca()),)
            ),
           
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              subtitle: Text('Informações sobre o aplicativo'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()=> Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrocarEmail()),)
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
                  padding:  EdgeInsets.only(top: screenHeigth * 0.08),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 17, 0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                   width: screenWidth * 0.8,
                    height: 50,
                  
                    child: Center(child: Text( 'Encerrar sessão', 
                    style: TextStyle(color: Colors.white, fontSize:screenWidth * 0.07 , fontWeight: FontWeight.bold),)),
                  ),
                ),

          ],
        )
      ),
    );
  }
}