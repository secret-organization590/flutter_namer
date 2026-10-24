import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: PairView()));
  }
}

class BigCard extends StatelessWidget {
  final WordPair wordPair;

  const new({super.key, required this.wordPair});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          wordPair.asLowerCase,
          style: style,
          semanticsLabel: '${wordPair.first} ${wordPair.second}',
        ),
      ),
    );
  }
}

class PairView extends StatefulWidget {
  const new({super.key});

  @override
  State<PairView> createState() => _PairViewState();
}

class _PairViewState extends State<PairView> {
  final viewModel = PairViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: .center,
          spacing: 12.0,
          children: [
            BigCard(wordPair: viewModel.wordPair),
            Row(
              mainAxisSize: .min,
              spacing: 12.0,
              children: [
                ElevatedButton.icon(
                  icon: Icon(
                    viewModel.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    viewModel.toggleFavorite();
                  },
                  label: const Text('Favorite'),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.generateRandom();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PairViewModel extends ChangeNotifier {
  WordPair wordPair = .random();
  bool get isFavorite => favorites.contains(wordPair);
  List<WordPair> favorites = [];

  void generateRandom() {
    wordPair = WordPair.random();

    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(wordPair)) {
      favorites.remove(wordPair);
    } else {
      favorites.add(wordPair);
    }

    notifyListeners();
  }
}
