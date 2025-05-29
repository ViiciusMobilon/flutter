import 'package:flutter/material.dart';

main() => runApp(Materialwidget());

class Materialwidget extends StatelessWidget {
  void _onFabPressed() {
    print("FAB pressionado!");
  }
  const Materialwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home:Scaffold
      ( appBar: AppBar(
        title: Text('Exemplo FAB'),
      ),

      body: Center(
        child: Container(
          height: 300,
         width: 200,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                  MyWidget(),
                  SizedBox(height: 30,),
                  senha(),
                
               
                Container(
                  
                  child: Text('Conteúdo da tela'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed ,
        tooltip: 'Adicionar',
        child: Text("ola mundo")
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label:"home"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "abc")
      ],)
      ,
         ), 
    );
  }
}

class senha extends StatefulWidget {
  const senha({super.key});

  @override
  _senhaState createState() =>_senhaState();
}

class _senhaState extends State<senha> {
  @override
  bool senha = true;

  void mudarvisao(){
    setState(() {
      senha=! senha;
    });
  }
  Widget build(BuildContext context) {
    return 
          TextField(
                   
                   maxLength: 5,  
                   autofocus: false,
                   obscureText: senha,
             decoration: InputDecoration(
            labelText:"senha" ,labelStyle: TextStyle(color: Colors.black)  ,
            hintText: "123456",
            border: UnderlineInputBorder(
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 255, 0, 0), width: 1.5),
              
            ),
            disabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            suffixIcon: IconButton( icon:Icon(senha ? Icons.visibility_off :Icons.visibility ), onPressed: mudarvisao )
             ),
               
        
         );
  }
}
 
 class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(

      decoration: InputDecoration(
        labelText:"email" ,labelStyle: TextStyle(color: Colors.black)  ,
            hintText: "blabla@gmail.com",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        )
      ),
    );
  }
}

