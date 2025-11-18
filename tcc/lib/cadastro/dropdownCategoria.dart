import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tcc/data/http/dio_client.dart' as apiHttp;
import 'package:tcc/data/models/Categoria.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/repositories/Categoria_repository.dart';

class Categoria extends StatefulWidget {
  final Userform usuario;
  final void Function(CategoriaModel?) onCategoriaSelecionado;
  final String? erro;
  final VoidCallback onClearerror;
  
  Categoria({
    super.key,
    required this.usuario,
    required this.onCategoriaSelecionado,
    required this.erro,
    required this.onClearerror
  });

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  late final CategoriaRepository categoriaRepository;
  CategoriaModel? Categoriaselecionado;

  @override
  void initState() {
    super.initState();
    categoriaRepository = CategoriaRepository(client: apiHttp.DioClient.dio);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    child: DropdownSearch<CategoriaModel>(
      items: (String filter, infiniteScrollProps) async {
        // Busca todas as categorias
        final categorias = await categoriaRepository.getCategoria();
        
        // Se houver filtro, aplica a busca local
        if (filter.isNotEmpty) {
          return categorias.where((categoria) => 
            categoria.nome.toLowerCase().contains(filter.toLowerCase())
          ).toList();
        }
        
        return categorias;
      },
      itemAsString: (CategoriaModel categoria) => categoria.nome,
      onChanged: (CategoriaModel? categoria) {
        setState(() {
          Categoriaselecionado = categoria;
        });
        widget.onCategoriaSelecionado(categoria);
        widget.onClearerror();
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: "Pesquisar categoria...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        fit: FlexFit.loose,
        constraints: BoxConstraints(
          maxHeight: 250,
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "Categoria",
          hintText: "Escolha a categoria",
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
          errorText: widget.erro,
        ),
      ),
      dropdownBuilder: (context, CategoriaModel? selectedItem) {
        return Text(
          selectedItem?.nome ?? "Escolha a categoria",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontFamily: "Poppins",
          ),
        );
      },
    ),
  );
}