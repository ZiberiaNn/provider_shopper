// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/catalog_screen.dart';

class cart extends StatelessWidget {
  const cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.displayLarge),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: cartlist(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            SizedBox(
              height: 200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Another way to listen to a model's change is to include
                    // the Consumer widget. This widget will automatically listen
                    // to CartModel and rerun its builder on every change.
                    //
                    // The important thing is that it will not rebuild
                    // the rest of the widgets in this build method.
                    Consumer<cartmodel>(
                        builder: (context, cart, child) => Text(
                            '\$${cart.totalPrice}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 48))),
                    const SizedBox(width: 24),
                    FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Buying not supported yet.')));
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('BUY'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class cartlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var cart = context.watch<cartmodel>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.items[index]);
          },
        ),
        title: Text(
          cart.items[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class cartmodel extends ChangeNotifier {
  /// The private field backing [catalog].
  late catalogmodel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  final List<int> _items = [];

  /// The current catalog. Used to construct items from numeric ids.
  catalogmodel get catalog => _catalog;

  set catalog(catalogmodel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of items in the cart.
  List<Item> get items =>
      _items.map((id) => _catalog.GetOneItemBYId(id)).toList();

  /// The current total price of all items.
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  int total() {
    return items.fold(0, (total, current) => total + current.price);
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Item item) {
    _items.add(item.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    print("A");
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}
