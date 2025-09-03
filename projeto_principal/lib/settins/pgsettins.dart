import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_principal/cadastro/Escolha.dart';

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
              onTap: () {
                // Ação ao clicar na opção
              },
            ),
         
           
           
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              subtitle: Text('Informações sobre o aplicativo'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Ação ao clicar na opção
              },
            ),

             ListTile(
              leading: Icon(Icons.info),
              title: Text('Acesso e segurança'),
              subtitle: Text('Configurações de segurança'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Ação ao clicar na opção
              },
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
                leading: Icon(Icons.accessibility),
                title: Text('Acessibilidade'),
                subtitle: Text('Configurações de acessibilidade'),
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
                  padding:  EdgeInsets.only(top: screenHeigth * 0.17),
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