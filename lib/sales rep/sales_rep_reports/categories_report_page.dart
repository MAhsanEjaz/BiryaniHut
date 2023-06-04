import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class CategoriesReportsPage extends StatefulWidget {
  const CategoriesReportsPage({Key? key}) : super(key: key);

  @override
  State<CategoriesReportsPage> createState() => _CategoriesReportsPageState();
}

class _CategoriesReportsPageState extends State<CategoriesReportsPage> {
  @override
  void initState() {
    super.initState();
  }

  void getCategoriesHandler() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: const Text(
          "Categories Report",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        // crossAxisAlignment: Cross,

        children: [
          const ListTile(
            leading: Text("Cost of Goods Sold"),
            trailing: Text("43434"),
          ),
          const ListTile(
            leading: Text("Total Revenue"),
            trailing: Text("43434"),
          ),
          const ListTile(
            leading: Text("Profit"),
            trailing: Text("43434"),
          ),
          const ListTile(
            leading: Text("Profit Margin"),
            trailing: Text("43434"),
          ),
          const Divider(),
          Table(
            border: TableBorder.all(color: Colors.black26, width: 1.5),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: const [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Name',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Cost',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Revenue',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Profit Margin',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
              ]),
            ],
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Table(
              border: TableBorder.all(color: Colors.black26, width: 1.5),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  // custList.isEmpty
                  // ?

                  TableCell(
                      child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    // flex:2,
                                    child: Text(
                                  '${index + 1}',
                                  style: tableStyle,
                                  textAlign: TextAlign.center,
                                )),
                                const Expanded(
                                    // flex:3,
                                    child: Text(
                                  "jdklf",
                                  style: tableStyle,
                                  textAlign: TextAlign.center,
                                )),
                                const Expanded(
                                    // flex:2,
                                    child: Text(
                                  'djfkljdlkf',
                                  style: tableStyle,
                                  textAlign: TextAlign.center,
                                )),
                                const Expanded(
                                    // flex:2,
                                    child: Text(
                                  'fdklfjdlkf',
                                  // getDate(order.dateTime),
                                  style: tableStyle,
                                  textAlign: TextAlign.center,
                                )),
                                const Expanded(
                                    // flex:3,
                                    child: Text(
                                  '433',
                                  // order.status,
                                  style: tableStyle,
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            );
                          }))
                ])
              ],
            ),
          )
        ],
      )),
    );
  }
}
