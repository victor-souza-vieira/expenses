import 'dart:math';
import 'dart:ui';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]); */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber[200],
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      id: 't0',
      title: 'Conta #00',
      value: 40.00,
      date: DateTime.now().subtract(Duration(days: 0)),
    ),
    Transaction(
      id: 't1',
      title: 'Conta #01',
      value: 10.76,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 't2',
      title: 'Conta #02',
      value: 31.46,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: 't3',
      title: 'Conta #03',
      value: 21.30,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't4',
      title: 'Conta #04',
      value: 199.90,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't5',
      title: 'Conta #05',
      value: 251.99,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  _deleteTransaction(String transactionIndex) {
    if (transactionIndex.isEmpty) {
      return;
    }
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id.compareTo(transactionIndex) == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Despesas pessoais",
        /* style: TextStyle(
          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        ), */
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        )
      ],
    );
    final avaiableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Exibir gráfico'),
                Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
              ],
            ),
            if (_showChart)
              Container(
                height: avaiableHeight * 0.3,
                child: Chart(recentsTransactions: _recentTransactions),
              ),
            if (!_showChart)
              Container(
                height: avaiableHeight * 0.7,
                child: TransactionList(
                  transactions: _transactions,
                  onRemove: _deleteTransaction,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
