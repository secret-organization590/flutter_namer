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

class Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final viewModel = PairViewModel();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Widget page = switch (_selectedIndex) {
      0 => PairGeneratorView(viewModel: viewModel),
      1 => PairFavoritesView(viewModel: viewModel),

      _ => throw UnimplementedError(),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  selectedIndex: _selectedIndex,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: const Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: const Text('Favorites'),
                    ),
                  ],
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
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

class PairFavoritesView extends StatelessWidget {
  final PairViewModel viewModel;

  const new({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return ListView.builder(
      itemCount: viewModel.favorites.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.favorite),
          title: Text(viewModel.favorites.elementAt(index).asLowerCase),
        );
      },
    );
  }
}

class PairGeneratorView extends StatelessWidget {
  final PairViewModel viewModel;

  const new({super.key, required this.viewModel});

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
