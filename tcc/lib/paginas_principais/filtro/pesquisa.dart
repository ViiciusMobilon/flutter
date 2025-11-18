import 'package:flutter/material.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_dono_conta.dart';

class BarraDePesquisa extends SearchDelegate<String> {
  final BuildContext context;

  BarraDePesquisa(this.context);

  final List<String> dados = [
    "Pedreiro",
    "Pintor",
    "Eletricista",
    "Encanador",
    "Marceneiro",
    "Jardineiro",
    "Carpinteiro",
    "Soldador",
    "Técnico em Refrigeração",
    "Instalador de Ar Condicionado",
  ];

  final Map<String, Map<String, dynamic>> _meta = {
    "Pedreiro": {"likes": 120, "views": 2000, "rating": 4.2, "date": "2025-09-30"},
    "Pintor": {"likes": 45, "views": 800, "rating": 3.8, "date": "2025-10-03"},
    "Eletricista": {"likes": 230, "views": 5000, "rating": 4.7, "date": "2025-09-25"},
    "Encanador": {"likes": 60, "views": 1200, "rating": 4.0, "date": "2025-09-29"},
    "Marceneiro": {"likes": 15, "views": 400, "rating": 3.5, "date": "2025-08-10"},
    "Jardineiro": {"likes": 5, "views": 150, "rating": 3.0, "date": "2025-07-20"},
    "Carpinteiro": {"likes": 90, "views": 1300, "rating": 4.1, "date": "2025-10-01"},
    "Soldador": {"likes": 40, "views": 560, "rating": 3.9, "date": "2025-09-15"},
    "Técnico em Refrigeração": {"likes": 75, "views": 900, "rating": 4.3, "date": "2025-09-27"},
    "Instalador de Ar Condicionado": {"likes": 150, "views": 2200, "rating": 4.6, "date": "2025-09-20"},
  };

  final Map<String, String> segmentoMap = {
    "Pedreiro": "Empresa",
    "Marceneiro": "Prestador",
    "Carpinteiro": "Empresa",
    "Pintor": "Prestador",
    "Jardineiro": "Empresa",
    "Eletricista": "Prestador",
    "Encanador": "Empresa",
    "Soldador": "Prestador",
    "Técnico em Refrigeração": "Empresa",
    "Instalador de Ar Condicionado": "Prestador",
  };

  // ------------ FILTROS ------------
  String? filtroTempo;
  DateTime? filtroDataInicio;
  DateTime? filtroDataFim;
  RangeValues filtroCurtidas = RangeValues(0, 1000);
  Set<String> filtroSegmentosSelecionados = {};
  double filtroAvaliacaoMinima = 0.0;

  int get _numeroFiltrosAtivos {
    int count = 0;
    if (filtroTempo != null) count++;
    if (filtroCurtidas.start > 0 || filtroCurtidas.end < 1000) count++;
    if (filtroSegmentosSelecionados.isNotEmpty) count++;
    if (filtroAvaliacaoMinima > 0.0) count++;
    return count;
  }

  // 👉 Placeholder
  @override
  String get searchFieldLabel => "Buscar profissionais...";

  // 👉 ESTILO DO TEXTO DIGITADO
  @override
  TextStyle? get searchFieldStyle => TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.w800,
        fontFamily: "Poppins",
      );

  // 👉 ESTILO DO PLACEHOLDER
  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontWeight: FontWeight.w800,
          fontFamily: "Poppins",
        ),
        border: InputBorder.none,
      );

  // 👉 Estilo visual da SearchBar
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  // ------------ AÇÕES (Ícone Filtro) ------------
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () => _abrirPainelFiltros(context),
          ),
          if (_numeroFiltrosAtivos > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_numeroFiltrosAtivos',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  // ------------ PAINEL DE FILTROS ------------
 void _abrirPainelFiltros(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateModal) {
          void limparTudo() {
            setStateModal(() {
              filtroTempo = null;
              filtroDataInicio = null;
              filtroDataFim = null;
              filtroCurtidas = const RangeValues(0, 1000);
              filtroSegmentosSelecionados.clear();
              filtroAvaliacaoMinima = 0.0;
            });
          }

          void aplicar() {
            Navigator.pop(context);
            showResults(context);
          }

          final segmentosDisponiveis = segmentoMap.values.toSet().toList();
          final width = MediaQuery.of(context).size.width;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 12,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextButton(
                        onPressed: limparTudo,
                        child: const Text(
                          'Limpar',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  const Text(
                    'Curtidas (intervalo)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),

                  RangeSlider(
                    values: filtroCurtidas,
                    min: 0,
                    max: 1000,
                    divisions: 1000,
                    labels: RangeLabels(
                      filtroCurtidas.start.round().toString(),
                      filtroCurtidas.end.round().toString(),
                    ),
                    onChanged: (v) => setStateModal(() => filtroCurtidas = v),
                    activeColor: const Color(0xFF1976D2),
                    inactiveColor: const Color(0xFF1976D2).withOpacity(0.3),
                  ),

                  const Divider(),

                  const Text(
                    'Segmento',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),

                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 8,
                    children: segmentosDisponiveis.map((seg) {
                      final selected =
                          filtroSegmentosSelecionados.contains(seg);

                      return FilterChip(
                        label: Text(
                          seg,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF1976D2),
                            fontFamily: "Poppins",
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: selected,
                        onSelected: (sel) => setStateModal(() {
                          if (sel) {
                            filtroSegmentosSelecionados.add(seg);
                          } else {
                            filtroSegmentosSelecionados.remove(seg);
                          }
                        }),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1976D2),
                        side: const BorderSide(
                          color: Color(0xFF1976D2),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: width * 0.015,
                        ),
                      );
                    }).toList(),
                  ),

                  const Divider(),

                  const Text(
                    'Avaliação mínima',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),

                  Slider(
                    value: filtroAvaliacaoMinima,
                    min: 0,
                    max: 5,
                    divisions: 100,
                    label: filtroAvaliacaoMinima.toStringAsFixed(1),
                    onChanged: (v) =>
                        setStateModal(() => filtroAvaliacaoMinima = v),
                    activeColor: const Color(0xFF1976D2),
                    thumbColor: const Color(0xFF1976D2),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: aplicar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
  // ------------ RESULTADOS ------------
  @override
  Widget buildResults(BuildContext context) {
    final resultados = dados.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text("Nenhum profissional encontrado", style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final item = resultados[index];
        final meta = _meta[item]!;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PerfilUser())),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF5E35B1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item[0].toUpperCase(),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 211, 0, 0),
                          fontSize: MediaQuery.of(context).size.height * 0.0035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "data",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppis",
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              segmentoMap[item] ?? "Serviço",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w400,
                                fontFamily: "poppis",
                              ),
                            ),
                            Text(
                              " ● ",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w400,
                                fontFamily: "poppis",
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                            Text(" ${meta['rating']}  "),
                            const Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 17),
                            Text(" ${meta['likes']}  "),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------ BOTÃO VOLTAR ------------
  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => close(context, ""),
      );

  // ------------ SUGESTÕES ------------
  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes = query.isEmpty
        ? dados.take(5).toList()
        : dados.where((item) => item.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final sugestao = sugestoes[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: Text(sugestao),
          onTap: () {
            query = sugestao;
            showResults(context);
          },
        );
      },
    );
  }
}
