import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_principal/cadastro/Escolha.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';
import 'package:projeto_principal/data/models/cep.dart';
import 'package:projeto_principal/data/models/user.dart';
import 'package:projeto_principal/data/repositories/auth_repository.dart';
import 'package:projeto_principal/data/repositories/cep_repository.dart';
import 'package:projeto_principal/data/services/auth_service.dart';
import 'package:projeto_principal/paginas%20principais/pagina_principal.dart';
import 'package:projeto_principal/data/http/http_client.dart' as apiHttp;



final cepMaskFormatter = MaskTextInputFormatter(
  mask: '#####-###',
  filter: { "#": RegExp(r'[0-9]') },
);

// void main() => runApp(const CEP());
final numeromaskFormatter = MaskTextInputFormatter(
  mask: '#####',
  filter: { "#": RegExp(r'[0-9]') },
);

class CEP extends StatefulWidget {
  final UsuarioGeral usuario;
  CEP({super.key, required this.usuario});

  @override
  State<CEP> createState() => _CEPState();
}

class _CEPState extends State<CEP> {
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final ufController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final infoaddController = TextEditingController();
  

  void preencherCampos(CepModel endereco){
    setState(() {
        cepController.text = endereco.cep;
        cidadeController.text = endereco.localidade;
        estadoController.text = endereco.estado;
        ufController.text = endereco.uf;
        ruaController.text = endereco.logradouro;
      });
  }

  @override
  Widget build(BuildContext context) {
    print( "Email: ${widget.usuario.email}");
    print( "senha: ${widget.usuario.password}");
    print( "senhaconfirmation: ${widget.usuario.confirmation_password}");
    print( "Tipo: ${widget.usuario.tipo}");
    print( "nome: ${widget.usuario.nome}");
    print( "tel: ${widget.usuario.telefone}");
    print( "cpf: ${widget.usuario.cpf}");
    print( "cnpj: ${widget.usuario.cnpj}");
    print( "foto: ${widget.usuario.foto}");
    print( "ramo: ${widget.usuario.ramo}");
    print( "razao social: ${widget.usuario.razao_social}");
    print('estou em cep');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FD),
           leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.black),
  onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Escolha(usuario: UsuarioGeral(),)),
    );
  },
),
          title:  Text(
            "Endereço",
            style: TextStyle(color: Colors.black,
            fontSize: MediaQuery.of(context).size.width*0.07,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",),
             
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cepWidget(controller: cepController, onCepBuscado: preencherCampos),
            ),
                 
                  Padding(
                  padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.01,
                  ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.530, // igual aos outros TextFields
                      child: cidade(
                        controller: cidadeController,
                        onCepBuscado: preencherCampos,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.230, // menor, pq é sigla
                      child: estado(
                        controller: ufController,
                        onCepBuscado: preencherCampos,
                      ),
                    ),
                ]
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
               
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: RuaWidget(controller: ruaController,),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: numero(controller: numeroController,),
            ),Padding(
                  padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Center(child: adicionais(controller: infoaddController,)),
                ),
           Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.22,
                  ),
                  child: Center(child: botao(usuario: widget.usuario,
                  cepController: cepController,
                  cidadeController: cidadeController,
                  estadoController: estadoController,
                  ufController: ufController,
                  infoaddController: infoaddController,
                  numeroController: numeroController,
                  ruaController: ruaController,)),
                ),
          
                 
          ],
        ),
      ),
    );
  }
}
  

Widget cepField({
 required TextEditingController controller,
  required void Function(CepModel) onCepBuscado,
}) {
  return cepWidget(controller: controller, onCepBuscado: onCepBuscado);
}

class cepWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(CepModel) onCepBuscado;
   cepWidget({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<cepWidget> createState() => _cepState();
}

class _cepState extends State<cepWidget> {
  late final CepRepository cepRepository;
  @override
  void initState() {
    
    super.initState();
    cepRepository = CepRepository(client: apiHttp.HttpClient());
  }
  Future<void> buscarCep(String cep) async{
    if(cep.isEmpty) return;
    try {
      final endereco = await cepRepository.getCep(cep);
      widget.onCepBuscado(endereco);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar CEP: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: buscarCep,
      maxLength:10 ,
       keyboardType: TextInputType.number,
          inputFormatters: [cepMaskFormatter],
      
      decoration: InputDecoration(
      
        labelText: "CEP",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        
        hintText: "99999-999",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        focusedBorder:OutlineInputBorder(
           borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

Widget ruaField(
  {required TextEditingController controller}

){
  return RuaWidget(controller: controller);
}

class RuaWidget extends StatefulWidget {
  final TextEditingController controller;
  const RuaWidget({super.key, required this.controller});

  @override
  State<RuaWidget> createState() => _RuaState();
}

class _RuaState extends State<RuaWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "Rua / Avenida",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        hintText: "Avenida sei la",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
           
          ),
        ),
      ),
    );
  }
}

class numero extends StatefulWidget {
  final TextEditingController controller;
   numero({super.key, required this.controller});

  @override
  State<numero> createState() => _numeroState();
}

class _numeroState extends State<numero> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      inputFormatters: [numeromaskFormatter],
      maxLength: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "1234",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "numero",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}


class botao extends StatefulWidget {
 final UsuarioGeral usuario;
 final TextEditingController cepController;
 final TextEditingController cidadeController;
 final TextEditingController estadoController;
 final TextEditingController ufController;
 final TextEditingController ruaController;
 final TextEditingController numeroController;
 final TextEditingController infoaddController;
 botao({super.key, required this.usuario,
  required this.cepController,
  required this.cidadeController,
  required this.estadoController,
  required this.ufController,
  required this.ruaController,
  required this.numeroController,
  required this.infoaddController,
 });

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();

    // instancia o cliente HTTP
    final authService = AuthService(AuthRepository()); // cria o repository aqui
  _authController = AuthController(authService);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () async{
            widget.usuario.cep = widget.cepController.text;
            widget.usuario.cidade = widget.cidadeController.text;
            widget.usuario.estado = widget.estadoController.text;
            widget.usuario.uf = widget.ufController.text;
            widget.usuario.rua = widget.ruaController.text;
            widget.usuario.numero = widget.numeroController.text;
            widget.usuario.infoadd = widget.infoaddController.text;
          print( "Email: ${widget.usuario.email}");
          print( "senha: ${widget.usuario.password}");
          print( "senhaconfirmation: ${widget.usuario.confirmation_password}");
          print( "Tipo: ${widget.usuario.tipo}");
          print( "nome: ${widget.usuario.nome}");
          print( "tel: ${widget.usuario.telefone}");
          print( "cpf: ${widget.usuario.cpf}");
          print( "cnpj: ${widget.usuario.cnpj}");
          print( "foto: ${widget.usuario.foto}");
          print( "cep: ${widget.usuario.cep}");
          print( "rua: ${widget.usuario.rua}");
          print( "cidade: ${widget.usuario.cidade}");
          print( "estado: ${widget.usuario.estado}");
          print( "uf: ${widget.usuario.uf}");
          print( "num: ${widget.usuario.numero}");
          print( "info: ${widget.usuario.infoadd}");
          print( "ramo: ${widget.usuario.ramo}");
          print("tipo:${widget.usuario.tipo}");

            final resposta = await _authController.cadastro(
                widget.usuario.email!,
                widget.usuario.password!,
                widget.usuario.confirmation_password!,
                widget.usuario.tipo!,
                widget.usuario.nome ?? '',
                widget.usuario.razao_social ?? '',
                widget.usuario.telefone!,
                widget.usuario.cpf ?? '',
                widget.usuario.cnpj ?? '',
                widget.usuario.ramo ?? 0,
                widget.usuario.foto!,
                widget.usuario.cep!,
                widget.usuario.rua!,
                widget.usuario.cidade!,
                widget.usuario.estado!,
                widget.usuario.uf!,
                widget.usuario.numero!,
                widget.usuario.infoadd ?? ''
                );
          if (resposta) {
            // pegar token
            final token = await _authController.logado(); // ou getUser() se quiser o usuário

            if (token) {
              // só redireciona se o token existe
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaPrincipal(authController: _authController),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao gerar token")),
              );
            }
          } else if (_authController.errors != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_authController.errors!)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Cadastro realizado com sucesso!')),
            );
          }

        }, 
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: <BoxShadow>[
            //para todas as caracteristicas do boxshadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4), //posição
              blurRadius: 8, //fumaça
              spreadRadius: 1,
            ),
          ],
        ),
      
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Text(
                "Proximo",
                style: TextStyle(
                  color: const Color.from(
                    alpha: 1,
                    red: 0.988,
                    green: 0.984,
                    blue: 0.984,
                  ),
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class adicionais extends StatefulWidget {
  final TextEditingController controller;
   adicionais({super.key, required this.controller});
   @override
  State<adicionais> createState() => _adicionaisState();
}

class _adicionaisState extends State<adicionais> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 128,
      decoration: InputDecoration(
        hintText: "info",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "informações adicionais",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class cidade extends StatefulWidget {
  final TextEditingController controller;
  final void Function(CepModel) onCepBuscado;
  cidade({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<cidade> createState() => _CidadeState();
}

class _CidadeState extends State<cidade> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: "Cidade",
          hintText: "Digite o nome da cidade",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromRGBO(121, 180, 217, 1),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.03,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}



class estado extends StatefulWidget {
  final TextEditingController controller;
  final void Function(CepModel) onCepBuscado;
  estado({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<estado> createState() => _EstadoState();
}

class _EstadoState extends State<estado> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: "Estado",
          hintText: "Digite a sigla do estado (ex: SP)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromRGBO(121, 180, 217, 1),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.03,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
