import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:video_chat/Model/user.dart';
import 'package:video_chat/upload.dart';
import 'bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'page_navigator.dart';


class HomePage extends StatefulWidget {

  String groupId;
  final User user;
  final PageNavigatorState pageNavigatorState;

  HomePage(this.pageNavigatorState, this.user, this.groupId);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool toggle = false;
  var isDarkTheme;
  MovieListBloc movieListBloc;
 
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieListBloc = MovieListBloc();
    movieListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? Color(0xff000000) : Color(0xffffffff),
        floatingActionButton: Container(
          margin: const EdgeInsets.all(0.5),
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: isDarkTheme ? Color(0xff2663FF) : Color(0xff2663FF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: FloatingActionButton(
            elevation: 1,
            backgroundColor: isDarkTheme ? Color(0xff2663FF) : Color(0xff2663FF),
            onPressed: (){
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => NewPost(),
                ),
              );
            },
            child: Icon(
              Ionicons.create_outline,
              color: Color(0xffffffff),
              size: 27,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(
        iconTheme: IconThemeData(color:  isDarkTheme ? Color(0xffffffff) : Color(0xff000000)),
        automaticallyImplyLeading: true,
        elevation: 0.0,
        backgroundColor: isDarkTheme ? Color(0xff000000) : Color(0xffffffff),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,5.0),
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          StreamBuilder<List<DocumentSnapshot>>(
            stream: movieListBloc.movieStream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return GridView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0.4,
                      mainAxisSpacing: 0.4,
                      crossAxisCount: 2, //each line The number of Widget
                      childAspectRatio: 9 / 14
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        widget.pageNavigatorState.selectedGroupID = snapshot.data[index].documentID;
                        widget.pageNavigatorState.selectedGroupName = snapshot.data[index].data['groupName'];
                        widget.pageNavigatorState.setState((){});
                        widget.pageNavigatorState.setPage(2);
                      },
                      child: Stack(
                        children: <Widget>[
                          Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.only(top: 2.0, bottom: 2, left: 2, right: 2),
                            color: isDarkTheme ? Colors.black26 : Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: snapshot.data[index]["image"],
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDarkTheme ? Colors.white12 : Colors.black12,
                                        width: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end:Alignment.center,
                                          stops: [0.1,0.2,0.3,0.4,0.5],
                                          colors: [Colors.black26, Colors.black26, Colors.black26, Colors.transparent, Colors.transparent]
                                      )
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          color: Colors.black54,
                                          shape: BoxShape.rectangle,
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                        child: Text(
                                          'Starts\t:\t${snapshot.data[index]["groupName1"]}',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.fade,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 05,
                                      ),
                                      Container(
                                          color: Colors.transparent,
                                          height: 40,
                                          padding: EdgeInsets.all(0.0),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    snapshot.data[index]["groupName"],
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          )
                                      ),
                                      Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(0.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: (){},
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot.data[index]["image"],
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1.1,
                                                          ),
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            image: imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Username",
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: isDarkTheme ? Colors.white : Colors.white,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          )
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(2.8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      )
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    // delete post itself
    Firestore.instance
        .collection('Groups')
        .document(widget.groupId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    FirebaseStorage.instance.ref().child("post images.jpg").delete();
  }


  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      movieListBloc.fetchNextMovies();
    }
  }
}
