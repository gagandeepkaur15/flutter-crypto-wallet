import 'package:flutter/material.dart';
import 'package:flutter_wallet/qr.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'wallet_services.dart';
import 'package:realm/realm.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _address = TextEditingController();
  TextEditingController _amount = TextEditingController();

  late LoginRealm loginProvider;
  double _balance = 0.00;

  @override
  void initState() {
    super.initState();
    // Initialize the WalletServices provider and call the 'intialize' method
    final walletProvider = Provider.of<WalletServices>(context, listen: false);
    loginProvider = Provider.of<LoginRealm>(context, listen: false);
    final currentUser = loginProvider.currentUser;
    if (currentUser != null) {
      walletProvider.intialize(currentUser);
    }
    _fetchBalance(walletProvider);
  }

  void _fetchBalance(WalletServices walletProvider) async {
    if (walletProvider.myCredentials != null) {
      double balance =
          await walletProvider.getBalance(walletProvider.myCredentials!);
      setState(() {
        _balance = balance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Amount',
            style: TextStyle(fontSize: 30),
          ),
          Text(
            '$_balance', // Display the wallet balance here
            style: TextStyle(fontSize: 30),
          ),
          OutlinedButton(
              onPressed: () async {
                await loginProvider.getCurrentUser();
                User? currentUser = loginProvider.currentUser;
                if (currentUser != null) {
                  walletProvider.createWallet(currentUser).then((value) => print(
                      ":::::::::::::::::::::::::::::::::::::::::::::::Wallet created"));
                }
              },
              child: Text("Create Wallet")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    sendBottomSheet(context);
                  },
                  child: const Text('Send')),
              ElevatedButton(
                  onPressed: () {
                    receiveBottomSheet(context);
                  },
                  child: const Text('Receive')),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> sendBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 190,
                  child: TextField(
                    controller: _address,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter address',
                      // isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 190,
                  child: TextField(
                    controller: _amount,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter amount',
                      // isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      final walletProvider =
                          Provider.of<WalletServices>(context, listen: false);
                      String toAddress = _address.text;
                      String amount = _amount.text;

                      walletProvider.sendTransection(
                          toAddress, amount, walletProvider.myCredentials!);

                      walletProvider
                          .sendTransection(
                              toAddress, amount, walletProvider.myCredentials!)
                          .then((value) {
                        print(value);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error sending transaction: $error"),
                        ));
                      });
                    },
                    child: const Text("Send"))
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> receiveBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const QRGenerate();
    },
  );
}
