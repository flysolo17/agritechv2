import 'dart:convert';

import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/users/Customer.dart';

import 'package:agritechv2/models/product/Cart.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/models/users/Users.dart';

import 'package:agritechv2/views/auth/change_password.dart';
import 'package:agritechv2/views/auth/forgot_password.dart';
import 'package:agritechv2/views/auth/terms.dart';
import 'package:agritechv2/views/calcu/calculator.dart';
import 'package:agritechv2/views/custom%20widgets/bottom_nav.dart';
import 'package:agritechv2/views/nav/cart/cart.dart';

import 'package:agritechv2/views/nav/checkout/gcash_payment.dart';

import 'package:agritechv2/views/nav/buy/buy_2.dart';
import 'package:agritechv2/views/nav/cart/old_cart.dart';

import 'package:agritechv2/views/nav/checkout/checkout.dart';
import 'package:agritechv2/views/nav/favorites/favorites.dart';
import 'package:agritechv2/views/nav/inbox/inbox.dart';
import 'package:agritechv2/views/nav/map/view_pest_map.dart';
import 'package:agritechv2/views/nav/map/view_topic.dart';
import 'package:agritechv2/views/nav/messages/conversation.dart';
import 'package:agritechv2/views/nav/messages/messages.dart';
import 'package:agritechv2/views/nav/order/cancel_order.dart';
import 'package:agritechv2/views/nav/order/my_order.dart';
import 'package:agritechv2/views/nav/order/view_order.dart';
import 'package:agritechv2/views/nav/profile/addresses.dart';
import 'package:agritechv2/views/nav/profile/create_address.dart';
import 'package:agritechv2/views/nav/ratings/rating.dart';

import 'package:agritechv2/views/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/cms/Topic.dart';
import '../views/auth/login.dart';
import '../views/auth/signup.dart';
import '../views/nav/buy/products/search_product_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordPage();
        },
      ),
      GoRoute(
        path: '/verification',
        builder: (BuildContext context, GoRouterState state) {
          return const VerificationPage();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: '/terms',
        builder: (BuildContext context, GoRouterState state) {
          return const TermsScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MainNavigation();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'product/:id',
            builder: (BuildContext context, GoRouterState state) {
              return Buy2Page(productID: state.pathParameters['id']!);
            },
          ),
          GoRoute(
            path: 'messages',
            builder: (BuildContext context, GoRouterState state) {
              return const MessagesPage();
            },
          ),
          GoRoute(
            path: 'conversation',
            builder: (BuildContext context, GoRouterState state) {
              return ConversationPage(
                users: state.extra as Users,
              );
            },
          ),
          GoRoute(
            path: 'my-orders',
            builder: (BuildContext context, GoRouterState state) {
              return const MyOrdersPage();
            },
          ),
          GoRoute(
            path: 'favorites',
            builder: (BuildContext context, GoRouterState state) {
              return const FavoritesPage();
            },
          ),
          GoRoute(
            path: 'inbox',
            builder: (BuildContext context, GoRouterState state) {
              return const InboxPage();
            },
          ),
          GoRoute(
            path: 'cancel',
            builder: (BuildContext context, GoRouterState state) {
              return OrderCancellationPage(
                transactions: state.extra as Transactions,
              );
            },
          ),
          GoRoute(
            path: 'rate',
            builder: (BuildContext context, GoRouterState state) {
              return RatingPage(
                transactions: state.extra as Transactions,
              );
            },
          ),
          GoRoute(
            path: 'view-order/:id',
            builder: (BuildContext context, GoRouterState state) {
              return ViewOrderPage(transactionID: state.pathParameters['id']!);
            },
          ),
          GoRoute(
            path: 'checkout',
            builder: (BuildContext context, GoRouterState state) {
              List<OrderItems> orderItems =
                  (jsonDecode(state.extra.toString()) as List)
                      .map((item) => OrderItems.fromJson(item))
                      .toList();
              return CheckoutPage(orderItems: orderItems);
            },
          ),
          GoRoute(
            name: 'gcash-payment',
            path: 'gcash-payment',
            builder: (BuildContext context, GoRouterState state) {
              final Map<String, dynamic> extras =
                  state.extra as Map<String, dynamic>;

              return GcashPaymentMethod(
                  transactionID: extras['transactionID'] as String,
                  payment: Payment.fromJson(
                    jsonDecode(extras['payment']),
                  ),
                  customer: extras['customer'] as String);
            },
          ),
          GoRoute(
            path: 'cart',
            builder: (BuildContext context, GoRouterState state) {
              // List<Cart> cartItems =
              //     (jsonDecode(state.extra.toString()) as List)
              //         .map((item) => Cart.fromJson(item))
              //         .toList();
              return const CartPage();
            },
          ),
          GoRoute(
            path: 'calculator',
            builder: (BuildContext context, GoRouterState state) {
              return const CalulatorPage();
            },
          ),
          GoRoute(
            path: 'search',
            builder: (BuildContext context, GoRouterState state) {
              return const SearchProductPage();
            },
          ),
          GoRoute(
            path: 'address/:uid',
            builder: (BuildContext context, GoRouterState state) {
              return AddressesPage(userID: state.pathParameters['uid'] ?? "");
            },
          ),
          GoRoute(
            path: 'create-address',
            builder: (BuildContext context, GoRouterState state) {
              List<Address> addresses =
                  (jsonDecode(state.extra.toString()) as List)
                      .map((item) => Address.fromJson(item))
                      .toList();
              return CreateAddressPage(
                addresses: addresses,
              );
            },
          ),
          GoRoute(
            path: 'view-pest-map',
            builder: (BuildContext context, GoRouterState state) {
              String topic = state.extra.toString();
              return ViewPestMapPage(
                topic: topic,
              );
            },
          ),
          GoRoute(
            path: 'view-pest-map-topic',
            builder: (BuildContext context, GoRouterState state) {
              Topic topic = state.extra as Topic;

              return ViewTopic(
                topic: topic,
              );
            },
          ),
        ],
        redirect: (BuildContext context, GoRouterState state) {
          final authBloc = context.read<AuthBloc>();
          final authState = authBloc.state;
          print("current state:  $authState");

          final bool matchedLocation = state.matchedLocation == '/login';
          if (authState is UnAthenticatedState) {
            return matchedLocation ? null : '/login';
          }
          if (matchedLocation) {
            if (authState is AuthenticatedButNotVerified) {
              return '/verification';
            } else if (authState is UnAthenticatedState) {
              return '/login';
            } else {
              return '/';
            }
          }
          return null;
        },
      ),
    ],
  );
}
