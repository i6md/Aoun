import 'package:aoun_app/models/user/user_model.dart';
import 'package:flutter/material.dart';
class UsersScreen extends StatelessWidget
{
  List<UserModel> users =[
    UserModel(
        id: "1",
        name: "Meshal",
        phone: "+966******",
        email: "*****@gmail.com",
        building: "842",
        room: "101",
      pic: "null"
    ),
    UserModel(
        id: "2",
        name: "Turki",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "102",
        pic: "null"

    ),
    UserModel(
        id: "3",
        name: "Khaled",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "103",
        pic: "null"

    ),
    UserModel(
        id: "4",
        name: "Asem",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "104",
        pic: "null"

    ),
    UserModel(
        id: "5",
        name: "Osama",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "105",
        pic: "null"

    ),
    UserModel(
        id: "6",
        name: "Jehad",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "106",
        pic: "null"

    ),
    UserModel(
        id: "7",
        name: "Abdulrahman",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "107",
        pic: "null"

    ),
    UserModel(
        id: "8",
        name: "Nawaf",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "108",
        pic: "null"

    ),
    UserModel(
        id: "9",
        name: "Bader",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "109",
        pic: "null"

    ),
    UserModel(
        id: "1",
        name: "Meshal",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "101",
        pic: "null"

    ),
    UserModel(
        id: "2",
        name: "Turki",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "102",
        pic: "null"

    ),
    UserModel(
        id: "3",
        name: "Khaled",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "103",
        pic: "null"

    ),
    UserModel(
        id: "4",
        name: "Asem",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "104",
        pic: "null"

    ),
    UserModel(
        id: "5",
        name: "Osama",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "105",
        pic: "null"

    ),
    UserModel(
        id: "6",
        name: "Jehad",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "106",
        pic: "null"

    ),
    UserModel(
        id: "7",
        name: "Abdulrahman",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "107",
        pic: "null"

    ),
    UserModel(
        id: "8",
        name: "Nawaf",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "108",
        pic: "null"

    ),
    UserModel(
        id: "9",
        name: "Bader",
        phone: "+966******",
        email: "*****@gmail.com",
      building: "842",
      room: "109",
        pic: "null"

    ),

  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Users'
          ),
        ),
        body:ListView.separated(
            itemBuilder: (context,index)=> buildUserItem(users[index]),
            separatorBuilder: (context,index)=>
                Padding(
                  padding: const EdgeInsetsDirectional.only(start:20.0,),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: users.length)
    );
  }

  Widget buildUserItem(UserModel user)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 25.0,
          child: Text(
            '${user.id}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start:20.0,end: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  ),
                  //maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      'Phone:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${user.phone}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${user.email}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.delete
                  )
              ),
              IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.edit
                  )
              )
            ],
          ),
        ),

      ],
    ),
  );

}