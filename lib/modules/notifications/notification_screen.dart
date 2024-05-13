import 'dart:convert';

import 'package:aoun_app/models/user/ads_model.dart';
import 'package:aoun_app/modules/login/auth_service.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 3, 50, 71),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Offers',
                  style: GoogleFonts.readexPro(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Requests',
                  style: GoogleFonts.readexPro(color: Colors.black),
                ),
                // text: 'Requests',
              ),
            ],
            controller: _tabController,
          ),
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF0F1113),
              size: 32,
            ),
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.readexPro(fontSize: 20),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                notificationOffer(
                    title: 'Panadol',
                    name: 'Meshal Aldajani',
                    place: '839',
                    rating: '4.9'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Baloot',
                    name: 'Khaled Alnoubi',
                    place: '861',
                    rating: '4.5'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Vacuum',
                    name: 'Asem Alsayed',
                    place: '829',
                    rating: '4.8'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Riyadh - KFUPM',
                    name: 'Jehad Alrehaily',
                    place: '839',
                    rating: '5.0'),
                const Divider(
                  height: 10,
                ),
              ])),
              SingleChildScrollView(
                child: FutureBuilder<List<Widget>>(
                  future:
                      listingRequests(), // Your async function that returns a List<Widget>
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for data, show a loading indicator or placeholder
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle any errors that occurred during data fetching
                      return Text('Error loading data: ${snapshot.error}');
                    } else {
                      // Data is available, build your widgets
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: snapshot.data ??
                            [], // Use the data or an empty list
                      );
                    }
                  },
                ),
                //[
                //   notificationRequest(
                //       name: 'Meshal Aldajani', place: '839', rating: '4.3'),
                //   const Divider(
                //     height: 10,
                //   ),
                //   notificationRequest(
                //       name: 'Turki Alzahrani', place: '816', rating: '4.7'),
                //   const Divider(
                //     height: 10,
                //   ),
                //   notificationRequest(
                //       name: 'Osama Morsi', place: '830', rating: '4.6'),
                //   const Divider(
                //     height: 10,
                //   ),
                //   notificationRequest(
                //       name: 'Khaled Alnoubi', place: '826', rating: '5.0'),
                //   const Divider(
                //     height: 10,
                //   ),
                //   notificationRequest(
                //       name: 'Asem Alsayed', place: '861', rating: '4.9'),
                //   const Divider(
                //     height: 10,
                //   ),
                // ]
              ),
            ],
          ),
        ));
  }

  Future<List<Widget>> listingRequests() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here');
    var ownerId = await findUserId(token);
    List<dynamic> orders = [];
    //print(token);
    //_LoginScreenState.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };

    var items = await fetchAds(ownerId);

    for (int index = 0; index < items.length; index++) {
      final requestBody = {
        'list_type': 'all',
        'item_id': items[index].adId,
      };
      final response = await http.post(
          Uri.parse(
              'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_orders'),
          headers: requestHeaders,
          body: json.encode(requestBody));
      //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var itemOrders = data['orders'] as List;
        print(itemOrders);
        //itemOrders.map((order) => fromJson(order)).toList();
        orders = orders + itemOrders;
      } else if (response.body == '{"message": "No orders found."}') {
        return [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You do not have any orders yet.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ];
      } else {
        print(response.body);
        print(
            'Error viewing orders. Status code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to load orders');
      }
    }
    return orders.map((order) => fromJson(order)).toList();
  }

  Future<List<AdsModel>> fetchAds(String ownerId) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here');
    //print(token);
    //_LoginScreenState.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'list_type': 'by_owner',
      'owner_id': ownerId,
    };
    final response = await http.post(
        Uri.parse(
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_items'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var items = data['items'] as List;
      print(items);
      return items.map((item) => AdsModel.fromJson(item)).toList();
    } else {
      print(
          'Error viewing items. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load ads');
    }
  }

  Future<String> findUserId(String? token) async {
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    //final requestBody = {};
    final response = await http.get(
      Uri.parse(
          'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_user_info'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data['user']['user_id'];
    } else {
      print(
          'Error viewing user_id. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load user_info');
    }
  }

  Widget fromJson(Map<String, dynamic> json) {
    return notificationRequest(
        client_id: json['client_id'],
        item_id: json['item_id'],
        name: json['title'],
        place: json['client_building']);
  }

  Future<void> acceptOrder(String client_id, String item_id) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    //print('we reached here');
    //print(token);
    //_LoginScreenState.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'client_id': client_id,
      'item_id': item_id,
    };
    final response = await http.post(
        Uri.parse(
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/accept_order'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listingRequests();
      });
    } else {
      print(
          'Error accepting order. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Error accepting item');
    }
  }

  Future<void> rejectOrder(String client_id, String item_id) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    //print('we reached here');
    //print(token);
    //_LoginScreenState.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'client_id': client_id,
      'item_id': item_id,
    };
    final response = await http.post(
        Uri.parse(
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/reject_order'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listingRequests();
      });
    } else {
      print(
          'Error rejecting order. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Error accepting item');
    }
  }

  Widget notificationRequest(
          {required String client_id,
          required String item_id,
          required String name,
          required String place,
          String rating = '5.0'}) =>
      Container(
        width: double.infinity,
        height: 100,
        // decoration: BoxDecoration(
        //   color: FlutterFlowTheme.of(context).secondaryBackground,
        // ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    'https://picsum.photos/seed/413/600',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.readexPro(),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 70, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey,
                            size: 24,
                          ),
                          Text(
                            place,
                            style: GoogleFonts.readexPro(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 75, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber[300],
                            size: 24,
                          ),
                          Text(
                            rating,
                            style: GoogleFonts.readexPro(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    // color: FlutterFlowTheme.of(context)
                    //     .secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFFC0202),
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Color(0xFFFC0202),
                      size: 24,
                    ),
                    onPressed: () {
                      rejectOrder(client_id, item_id);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    // color: FlutterFlowTheme.of(context)
                    //     .secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 3, 50, 71),
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.check_rounded,
                      color: Color.fromARGB(255, 3, 50, 71),
                      size: 24,
                    ),
                    onPressed: () {
                      acceptOrder(client_id, item_id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
