import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/models/ReviewWithCustomer.dart';
import 'package:agritechv2/models/product/Cart.dart';
import 'package:agritechv2/models/product/Shipping.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';

import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/review_repository.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/views/custom%20widgets/cart_action.dart';
import 'package:agritechv2/views/nav/buy/buy_now.dart';
import 'package:agritechv2/views/nav/ratings/product_rating.dart';
import 'package:agritechv2/views/nav/ratings/rating.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../blocs/cart/cart_bloc.dart';

import '../../../blocs/favorites/favorites_bloc.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../models/favorites/favorites.dart';
import '../../../models/product/Products.dart';
import '../../../models/product/Variations.dart';
import '../../../repository/cart_repository.dart';
import '../../../repository/favorites_repository.dart';
import '../../../repository/product_repository.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/Constants.dart';

class Buy2Page extends StatefulWidget {
  final String productID;
  const Buy2Page({super.key, required this.productID});

  @override
  State<Buy2Page> createState() => _Buy2PageState();
}

class _Buy2PageState extends State<Buy2Page> {
  List<ReviewWithCustomer> _reviews = [];

  StreamSubscription? _reviewSubscription;

  @override
  void initState() {
    super.initState();
    initReviewStreams(widget.productID);
  }

  void initReviewStreams(String productID) {
    _reviewSubscription = context
        .read<ReviewRepository>()
        .combineStreams(widget.productID)
        .listen((event) {
      setState(() {
        _reviews = event;
      });
    });
  }

  @override
  void dispose() {
    _reviewSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductBloc(
                productRepository: context.read<ProductRepository>())
              ..add(GetProductByIDEvent(id: widget.productID)),
          ),
          BlocProvider(
              create: (context) => CartBloc(
                  cartRepository: context.read<CartRepository>(),
                  uid: context.read<AuthRepository>().currentUser?.uid ?? '')),
          BlocProvider(
              create: (context) => FavoritesBloc(
                  favoritesRepository: context.read<FavoritesRepository>(),
                  customerID:
                      context.read<AuthRepository>().currentUser?.uid ?? '')),
        ],
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              print(state.error.toString());
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductLoaded<Products>) {
              Products products = state.data;
              List<String> _images = state.data.images;
              List<Variation> variations = state.data.variations;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ImageSlider(
                            images: _images,
                            variations: variations,
                          ),
                          SalesInfo(
                            products: products,
                            reviews: _reviews,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  products.description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonActions(
                    products: products,
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(state.toString()),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductSold extends StatefulWidget {
  final String productID;

  const ProductSold({Key? key, required this.productID}) : super(key: key);

  @override
  State<ProductSold> createState() => _ProductSoldState();
}

class _ProductSoldState extends State<ProductSold> {
  int productSold = 0;

  @override
  void initState() {
    super.initState();
    initProductSold(widget.productID);
  }

  void initProductSold(String productID) {
    context
        .read<TransactionRepostory>()
        .computeProductsSold(productID)
        .then((value) {
      setState(() {
        productSold = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$productSold sold',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class ButtonActions extends StatelessWidget {
  final Products products;

  const ButtonActions({Key? key, required this.products}) : super(key: key);

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => CartBloc(
              cartRepository: context.read<CartRepository>(),
              uid: context.read<AuthRepository>().currentUser?.uid ?? ''),
          child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: VariationListChoices(
                products: products, variations: products.variations),
          ),
        );
      },
    );
  }

  void _showCheckoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BuyNowPage(products: products);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is CartSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.data)));
          }
        },
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  if (products.variations.isNotEmpty) {
                    _showBottomSheet(context);
                  } else {
                    Cart cart = Cart(
                        id: "",
                        userID: context.read<AuthRepository>().currentUser!.uid,
                        productID: products.id,
                        variationID: "",
                        isVariation: false,
                        quantity: 1,
                        createdAt: DateTime.now());
                    context.read<CartBloc>().add(AddToCartEvent(cart));
                  }
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: ColorStyle.brandGreen,
                ),
                label: const Text(
                  "ADD TO CART",
                  style: TextStyle(
                    color: ColorStyle.brandGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              color: ColorStyle.brandRed,
              child: TextButton(
                onPressed: () {
                  if (products.variations.isEmpty && products.stocks > 1) {
                    OrderItems orderItems = OrderItems(
                        productID: products.id,
                        productName: products.name,
                        isVariation: false,
                        variationID: "",
                        quantity: 1,
                        maxQuantity: products.stocks,
                        cost: products.cost,
                        price: products.price,
                        imageUrl: products.images[0],
                        shippingInfo: products.shippingInformation);
                    List<OrderItems> orderList = [orderItems];
                    context.push('/checkout',
                        extra: jsonEncode(
                            orderList.map((e) => e.toJson()).toList()));
                  } else {
                    _showCheckoutBottomSheet(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Buy now",
                    style: TextStyle(color: Colors.white),
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

class VariationListChoices extends StatefulWidget {
  final Products products;
  final List<Variation> variations;
  const VariationListChoices(
      {super.key, required this.products, required this.variations});

  @override
  State<VariationListChoices> createState() => _VariationListChoicesState();
}

class _VariationListChoicesState extends State<VariationListChoices> {
  int _selectedIndex = -1;
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: ColorStyle.brandRed, width: 1.0),
              ),
              margin: const EdgeInsets.all(5.0),
              width: 100,
              height: 100,
              child: _selectedIndex == -1
                  ? Image.network(
                      widget.products.images[0],
                      fit: BoxFit.contain,
                    )
                  : widget.variations[_selectedIndex].image.isEmpty
                      ? Image.asset(
                          'lib/assets/images/no_image.png',
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          widget.variations[_selectedIndex].image,
                          fit: BoxFit.contain,
                        ),
            ),
            if (_selectedIndex != -1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₱ ${widget.variations[_selectedIndex].price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorStyle.brandGreen),
                  ),
                  Text(
                    "Stocks : ${widget.variations[_selectedIndex].stocks}",
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              )
          ],
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Variations",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: 5.0,
          runSpacing: 8.0,
          children: widget.variations.mapIndexed(
            (index, variation) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedIndex == index
                          ? ColorStyle.brandRed
                          : Colors.transparent,
                      width: 1.0,
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      variation.image.isNotEmpty
                          ? Image.network(
                              variation.image,
                              fit: BoxFit.contain,
                              height: 25,
                              width: 25,
                            )
                          : Image.asset(
                              'lib/assets/images/no_image.png',
                              fit: BoxFit.contain,
                              height: 25,
                              width: 25,
                            ),
                      Text(
                        variation.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
        const Divider(),
        if (_selectedIndex != -1)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Quantity",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InputQty(
                maxVal: widget.variations[_selectedIndex].stocks,
                initVal: 1,
                minVal: 1,
                steps: 1,
                onQtyChanged: (val) {
                  setState(() {
                    _quantity = val;
                  });
                },
              ),
            ],
          ),
        const Spacer(),
        BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is CartSuccessState<String>) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.data)));
              context.pop();
            }
          },
          builder: (context, state) {
            return state is CartLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: _selectedIndex == -1 ||
                            widget.variations[_selectedIndex].stocks < 1
                        ? null
                        : () {
                            Cart cart = Cart(
                                id: "",
                                userID: context
                                    .read<AuthRepository>()
                                    .currentUser!
                                    .uid,
                                productID: widget.products.id,
                                variationID:
                                    widget.variations[_selectedIndex].id,
                                quantity: _quantity,
                                isVariation: true,
                                createdAt: DateTime.now());
                            context.read<CartBloc>().add(AddToCartEvent(cart));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == -1
                          ? Colors.grey
                          : ColorStyle.brandRed,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      _selectedIndex == -1
                          ? "Select a variation"
                          : "Add to cart",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final List<Variation> variations;
  const ImageSlider(
      {super.key, required this.images, required this.variations});
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> _imageList = [];
  @override
  void initState() {
    super.initState();
    _imageList.addAll(widget.images);
    _imageList.addAll(widget.variations.map((e) => e.image));
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 250,
              child: PageView(
                controller: _pageController,
                children: _imageList.map((image) {
                  return Container(
                    margin: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'lib/assets/images/no_image.png',
                            fit: BoxFit.contain,
                          ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${_currentPage + 1}/${_imageList.length}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            CustomAppBar(),
          ],
        ),
        if (widget.variations.isNotEmpty)
          Container(
            color: Colors.grey[200],
            child: HorizontalList(
                title: _currentPage == widget.images.length - 1
                    ? "${widget.variations.length} variations available"
                    : widget.variations[_currentPage - 1].name,
                selectedIndex: _currentPage - widget.images.length,
                variations: widget.variations,
                onTap: (value) {
                  print('${(widget.images.length + value) - 1}');
                  _pageController.jumpToPage(widget.images.length + value);
                }),
          ),
      ],
    );
  }
}

class HorizontalList extends StatelessWidget {
  final List<Variation> variations;
  String title;
  int selectedIndex;
  final Function(int index) onTap;

  HorizontalList(
      {Key? key,
      required this.variations,
      required this.onTap,
      required this.title,
      required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: variations.mapIndexed((index, variation) {
                return GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: index == selectedIndex
                            ? ColorStyle.brandRed
                            : Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    width: 100,
                    child: variation.image.isNotEmpty
                        ? Image.network(
                            variation.image,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'lib/assets/images/no_image.png',
                            fit: BoxFit.contain,
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesInfo extends StatelessWidget {
  final Products products;
  final List<ReviewWithCustomer> reviews;
  const SalesInfo({super.key, required this.products, required this.reviews});
  num sumRatings(List<ReviewWithCustomer> reviewWithCustomers) {
    return reviews.fold(0, (num sum, ReviewWithCustomer reviewWithCustomer) {
      return sum + reviewWithCustomer.reviews.rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            products.name,
            style: MyTextStyles.header,
          ),
          Text(
            getEffectivePrice(products),
            style: MyTextStyles.text,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: sumRatings(reviews).toDouble(),
                    itemCount: 5,
                    itemSize: 20.0,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${sumRatings(reviews).toDouble()}',
                    style: MyTextStyles.textBold,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ProductSold(
                    productID: products.id,
                  )
                ],
              ),
              HeartIcon(productID: products.id)
            ],
          ),
        ],
      ),
    );
  }
}

class HeartIcon extends StatelessWidget {
  final String productID;
  const HeartIcon({super.key, required this.productID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Favorites>>(
      stream: context.read<FavoritesBloc>().favoritesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Icon(Icons.circle);
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else {
          List<Favorites> favoritesList = snapshot.data ?? [];

          bool isFavorite =
              favoritesList.any((favorite) => favorite.productID == productID);

          return isFavorite
              ? IconButton(
                  onPressed: () {
                    context.read<FavoritesBloc>().add(RemoveFromFavorites(
                        productID,
                        context.read<AuthRepository>().currentUser?.uid ?? ''));
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: ColorStyle.brandRed,
                  ))
              : IconButton(
                  onPressed: () {
                    if (!isFavorite) {
                      context.read<FavoritesBloc>().add(AddFavoritesEvent(
                          Favorites(
                              id: '',
                              productID: productID,
                              customerID: context
                                      .read<AuthRepository>()
                                      .currentUser
                                      ?.uid ??
                                  '',
                              createdAt: DateTime.now())));
                    }
                  },
                  icon: const Icon(Icons.favorite_border_outlined));
        }
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(
          Icons.arrow_back,
          size: 24,
        ),
        onPressed: () => context.pop(),
        color: Colors.black, // Icon color
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.2), // Background color with opacity
                shape: BoxShape.circle, // Circular shape
              ),
              child: const CartAction()),
        )
      ],
    );
  }
}
