import 'package:agritechv2/blocs/favorites/favorites_bloc.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/favorites_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/favorites/favorites.dart';
import '../../../models/product/Products.dart';
import '../../../repository/product_repository.dart';
import '../../../utils/Constants.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc(
        favoritesRepository: context.read<FavoritesRepository>(),
        customerID: context.read<AuthRepository>().currentUser?.uid ?? '',
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorStyle.brandRed,
          title: const Text('My Favorites'),
        ),
        body: const FavoritesList(),
      ),
    );
  }
}

class FavoritesList extends StatelessWidget {
  const FavoritesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Favorites>>(
      stream: context.read<FavoritesBloc>().favoritesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Icon(Icons.error));
        } else {
          List<Favorites> favoritesList = snapshot.data ?? [];

          if (favoritesList.isEmpty) {
            // Display a message when there are no favorites
            return const Center(child: Text('No favorites yet!.'));
          }

          return ListView.builder(
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              return FavoriteCard(favorites: favoritesList[index]);
            },
          );
        }
      },
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final Favorites favorites;

  const FavoriteCard({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Products>(
      stream: context
          .read<ProductRepository>()
          .getProductStreamById(favorites.productID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmerLoading1(); // Loading indicator
        } else if (snapshot.hasError) {
          return Card(
            child: ListTile(
              leading: Image.asset('lib/assets/no_image.png'),
              title: const Text('Unknown Product'),
              subtitle: const Text('Product might be deleted!'),
              trailing: IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(
                      favorites.productID,
                      context.read<AuthRepository>().currentUser?.uid ?? ''));
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Card(
            child: ListTile(
              leading: Image.asset('lib/assets/no_image.png'),
              title: const Text('Unknown Product'),
              subtitle: const Text('Product might be deleted!'),
              trailing: IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(
                      favorites.productID,
                      context.read<AuthRepository>().currentUser?.uid ?? ''));
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
              // Add other UI components as needed
            ),
          );
        } else {
          final Products? products = snapshot.data;
          if (products != null) {
            return GestureDetector(
              onTap: () => context.go('/product/${products.id}'),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1, // Adjust the aspect ratio as needed
                    child: Image.network(
                      products.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(products.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${products.stocks} items left '),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatPrice(products.price),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorStyle.brandRed),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<FavoritesBloc>().add(
                                  RemoveFromFavorites(
                                      favorites.productID,
                                      context
                                              .read<AuthRepository>()
                                              .currentUser
                                              ?.uid ??
                                          ''));
                            },
                            icon: const Icon(Icons.favorite),
                            color: ColorStyle.brandRed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Card(
            child: ListTile(
              leading: Image.asset('lib/assets/no_image.png'),
              title: const Text('Unknown Product'),
              subtitle: const Text('Product might be deleted!'),
              trailing: IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(
                      favorites.productID,
                      context.read<AuthRepository>().currentUser?.uid ?? ''));
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ),
          );
        }
      }, // Closing parenthesis was missing here
    );
  }
}
