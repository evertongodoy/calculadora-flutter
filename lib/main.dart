import 'package:flutter/material.dart';

// Ponto de partida do programa em Dart (e Flutter).
// É aqui que o Flutter inicia a execução do app.
void main() {
  // runApp 
    // Função fornecida pelo framework Flutter.
    // Recebe um widget (geralmente o widget raiz da aplicação) e o insere na árvore principal do app.
    // É responsável por inicializar o binding entre o motor gráfico do Flutter e a interface do usuário.
  // const
    // Um widget customizado representando toda a sua aplicação de calculadora.
    // Como é marcado com const, isso sinaliza ao Flutter que o widget é imutável (sem mudança de estado) e pode ser otimizado em tempo de compilação — resultando em melhor performance.
  runApp(const CalculadoraApp());
}

// Definindo um widget chamado CalculadoraApp.
// Ele herda de StatelessWidget, o que significa que não mantém estado interno e é imutável depois de criado
class CalculadoraApp extends StatelessWidget {
  // Construtor marcado como const: isso permite que o Flutter otimize esse widget em tempo de compilação, já que suas propriedades não mudam .
  // super.key passa a Key (identificador opcional) para a classe-pai, ajudando com o gerenciamento de widgets na árvore.
  const CalculadoraApp({super.key});

  // Aqui começa o método build, obrigatório em todos os widgets.
  // Recebe BuildContext, que carrega informações sobre onde esse widget está na árvore, e deve retornar outro widget que descreva como será renderizado na tela.
  @override
  Widget build(BuildContext context) {
    // Retorna um MaterialApp: widget de nível superior para apps com estilo Material Design
    // Ele cuida de tema, navegação (Navigator), internacionalização, rotas, etc.
    return MaterialApp(
      // Define o título da aplicação: utilizado pelo sistema operacional (ex: título da janela ou gerenciador de tarefas)
      title: 'Calculadora Flutter',
      // theme: define o tema visual da sua app (cores, tipografia, estilo de botões).      
      theme: ThemeData(
        // // cria um esquema de cores coerente com base na cor “seed” fornecida
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 50, 139, 207)),
      ),
      // Remove o banner “DEBUG” exibido por padrão quando a app está em modo de depuração (debug).
      debugShowCheckedModeBanner: false,
      // home define o widget raiz da tela inicial.
      // Também é marcado como const para otimização.
      home: const CalculadoraScreen(title: 'Calculadora - SENAC'),
    );
  }
}

// Define um novo widget chamado CalculadoraScreen
// Ele estende StatefulWidget, indicando que possui estado mutável gerenciado internamente
class CalculadoraScreen extends StatefulWidget {
  // Construtor const — indica que esse widget é imutável após criado, permitindo otimização.
  // super.key: repassa o parâmetro key (identificador opcional para gerenciamento na árvore de widgets) para a classe-pai
  // required this.title: define que o parâmetro title (um String) é obrigatório. Ele também inicializa o campo final title.
  const CalculadoraScreen({super.key, required this.title});
  // Declara um campo imutável (final) que armazena o título da tela. Esse valor é definido via construtor e não muda depois.
  final String title;

  // Implementa o método createState() — obrigatório em StatefulWidget.
  // Ele retorna uma instância da classe _CalculadoraScreenState, que contém a lógica e o estado da tela.
  // Cada vez que o widget é colocado na árvore, o Flutter chama createState() para construir o estado correspondente
  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

// Define a classe de estado para o widget CalculadoraScreen.
// Ao estender State<CalculadoraScreen>, você associa esse estado ao widget correspondente, permitindo gerenciar e reagir a mudanças.
class _CalculadoraScreenState extends State<CalculadoraScreen> {
  
  // Cria dois controladores para cada TextField: _c1 e _c2.
  // TextEditingController permite ler, editar e ouvir os textos digitados nos campos
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();
  // Declara um campo privado que armazena o resultado calculado.
  // Inicialmente vazio ('') e será atualizado dinamicamente com setState().
  String _resultado = '';

  // Define um método privado (_calcular) que recebe uma operação (+, -, *, /) e executa a lógica da calculadora. 
  void _calcular(String op) {
    // Extrai o texto dos controladores e faz o parse para double, permitindo vírgulas como separador decimal.
    // tryParse retorna null se a entrada for inválida.
    final n1 = double.tryParse(_c1.text.replaceAll(',', '.'));
    final n2 = double.tryParse(_c2.text.replaceAll(',', '.'));
    // Verifica se houve erro de parse (null).
    if (n1 == null || n2 == null) {
      // Se sim, usa setState() para atualizar _resultado e re-renderizar a UI , parando a execução com return.
      setState(() => _resultado = 'Entrada inválida');
      return;
    }

    // Executa a operação matemática com base em op
    // Inclui verificação contra divisão por zero.
    // Resultado armazenado em res.
    double res;
    switch (op) {
      case '+': res = n1 + n2; break;
      case '-': res = n1 - n2; break;
      case '*': res = n1 * n2; break;
      case '/':
        if (n2 == 0) {
          setState(() => _resultado = 'Divisão por zero');
          return;
        }
        res = n1 / n2; break;
      default: return;
    }
    // // Usa setState() para atualizar _resultado com o valor calculado convertido para string.
    // Isso aciona a reconstrução da UI para refletir o novo resultado
    setState(() => _resultado = res.toString());
  }

  // Método build() é chamado sempre que há mudanças – inicial ou após setState().
  // Retorna a estrutura visual atualizada da tela.
  @override
  Widget build(BuildContext context) {
    
    // Scaffold fornece a estrutura básica da tela: AppBar, corpo, etc.
    return Scaffold(
      // Define a barra superior com título fixo e cor baseada no tema atual.
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Usa Padding e Column para estruturar os widgets com espaçamento.
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Primeiro TextField vinculado a _c1.
            // Permite entrada numérica e exibe um rótulo.
            TextField(
              controller: _c1,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Digite um número, ex: 1'),
            ),
            //Segundo campo de texto, com as mesmas configurações, mas ligado a _c2.
            TextField(
              controller: _c2,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Digite um número, ex: 1'),
            ),
            // Cria espaço vertical entre campos e botões.
            const SizedBox(height: 16),
            // Linha com quatro botões para as operações. Cada um chama _calcular com o operador correspondente ao ser pressionado.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _calcular('+'), child: const Text('+')),
                ElevatedButton(onPressed: () => _calcular('-'), child: const Text('-')),
                ElevatedButton(onPressed: () => _calcular('*'), child: const Text('*')),
                ElevatedButton(onPressed: () => _calcular('/'), child: const Text('/')),
              ],
            ),
            // Espaço adicional antes de exibir o resultado.
            const SizedBox(height: 24),
            // Exibe o resultado atual, com estilo destacado. Atualiza automaticamente sempre que _resultado muda.
            Text(
              _resultado,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
