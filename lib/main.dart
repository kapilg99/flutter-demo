import 'package:flutter/material.dart';
import 'package:flutter_crud/models/member.dart';
import 'package:flutter_crud/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter SQLite CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Member _member = Member();
  List<Member> _memberList = [];
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _controlName = TextEditingController();
  final _controlPhone = TextEditingController();
  final _controlCity = TextEditingController();
  final _controlPin = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
    });
    _refreshMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          title: Center(
        child: Text(widget.title),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _controlName,
                onSaved: (val) => setState(() => _member.name = val.trim()),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone Number"),
                controller: _controlPhone,
                onSaved: (val) =>
                    setState(() => _member.phone_no = int.parse(val.trim())),
                validator: (val) => (val.contains(new RegExp(r'[0-9]{10}'))
                    ? null
                    : "Enter a 10 digit phone number"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "City"),
                controller: _controlCity,
                onSaved: (val) => setState(() => _member.city = val.trim()),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Pin number"),
                controller: _controlPin,
                onSaved: (val) =>
                    setState(() => _member.pin_no = int.parse(val.trim())),
                validator: (val) =>
                    (val.trim().contains(new RegExp(r'[0-9]{6}'))
                        ? null
                        : "Enter a 6 digit pin number"),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text("Insert"),
                  color: Colors.lightBlueAccent,
                ),
              )
            ],
          ),
        ),
      );

  _list() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: ListView.builder(
            padding: EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.lightBlue,
                      size: 40.0,
                    ),
                    title: Text(
                      _memberList[index].name.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _memberList[index].phone_no.toString(),
                    ),
                    trailing: Wrap(
                      spacing: 3,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.create,
                            color: Colors.blueGrey,
                            size: 20.0,
                          ),
                          splashColor: Colors.blueGrey[200],
                          onPressed: () {
                            setState(() {
                              _member = _memberList[index];
                              _controlName.text = _member.name;
                              _controlPhone.text = _member.phone_no.toString();
                              _controlCity.text = _member.city;
                              _controlPin.text = _member.pin_no.toString();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          splashColor: Colors.red[200],
                          onPressed: () async {
                            _databaseHelper.deleteMember(_memberList[index].id);
                            print("deleted");
                            _resetForm();
                            _refreshMemberList();
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 5.0,
                  ),
                ],
              );
            },
            itemCount: _memberList.length,
          ),
        ),
      );

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_member.id == null) {
        await _databaseHelper.insertMember(_member);
      } else {
        await _databaseHelper.updateMember(_member);
      }
      _refreshMemberList();
      _resetForm();
    } else {
      print("Validation not successful :(");
    }
  }

  _refreshMemberList() async {
    List<Member> x = await _databaseHelper.fetchMembers();
    setState(() {
      print("memberlist updated");
      x.forEach((element) {
        print(element.id.toString() +
            " " +
            element.name +
            " " +
            element.phone_no.toString());
      });
      _memberList = x;
    });
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _controlName.clear();
      _controlCity.clear();
      _controlPin.clear();
      _controlPhone.clear();
      _member.id = null;
    });
  }
}
