import 'package:agritechv2/blocs/cart/cart_bloc.dart';

import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/views/custom%20widgets/cart_action.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/product/product_bloc.dart';

import '../../../../models/product/Products.dart';
import '../../../../models/product/Variations.dart';
import '../../../../repository/cart_repository.dart';
import '../../../../repository/product_repository.dart';
import '../../../../styles/text_styles.dart';
import '../../../../utils/Constants.dart';

class ViewProductPage extends StatefulWidget {
  final String productID;
  const ViewProductPage({super.key, required this.productID});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  ScrollController _scrollController = ScrollController();
  bool _isExpanded = true;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();

    // Add a listener to the scroll controller
    _scrollController.addListener(() {
      // Check if the user has scrolled past a certain point (e.g., 100 pixels)
      if (_scrollController.offset > 100) {
        setState(() {
          _isExpanded = false;
        });
      } else {
        setState(() {
          _isExpanded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // Don't forget to dispose of the scroll controller when the widget is disposed
    _scrollController.dispose();
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
            create: (context) =>
                CartBloc(cartRepository: context.read<CartRepository>()),
          ),
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
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor:
                        !_isExpanded ? ColorStyle.brandRed : Colors.grey[200],
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      title: _isExpanded ? null : Text(''),
                      background:
                          ImageSlider(images: _images, variations: variations),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (variations.isNotEmpty)
                        VariationList(
                            variations: variations,
                            onTap: (data) {
                              setState(() {
                                _currentPage = _images.length + 1;
                              });
                            },
                            title: _currentPage == _images.length - 1
                                ? "${variations.length} variations available"
                                : variations[_currentPage - 1].name)
                    ]),
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

class ButtonActions extends StatefulWidget {
  const ButtonActions({super.key});

  @override
  State<ButtonActions> createState() => _ButtonActionsState();
}

class _ButtonActionsState extends State<ButtonActions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: ColorStyle.brandGreen,
              ),
              label: const Text(
                "ADD TO CART",
                style: TextStyle(
                    color: ColorStyle.brandGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            color: ColorStyle.brandRed,
            child: TextButton(
              onPressed: () {},
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
      ],
    );
  }
}

class VariationList extends StatelessWidget {
  final List<Variation> variations;
  String title;
  final Function(int index) onTap;

  VariationList({
    Key? key,
    required this.variations,
    required this.onTap,
    required this.title,
  }) : super(key: key);
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
          Text(title),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: variations.mapIndexed((index, variation) {
                return GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: SizedBox(
                    width: 80,
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
  const SalesInfo({super.key, required this.products});

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
                    rating: 2.5,
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
                    "2.5",
                    style: MyTextStyles.textBold,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "100 sold",
                    style: MyTextStyles.textBold,
                  ),
                ],
              ),
              const Icon(Icons.favorite_border_outlined),
            ],
          ),
        ],
      ),
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
        padding: EdgeInsets.all(0),
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
              padding: EdgeInsets.all(0),
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
