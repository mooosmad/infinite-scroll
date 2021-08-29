import 'package:flutter/material.dart';
import 'package:iscroll/data/api.dart';
import 'package:iscroll/model/lecture.dart';

class KekePlay extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<KekePlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          title: Text(
            'Keke Tv',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          color: Colors.black,
          child: FutureBuilder(
            future: MovieRepository().getNowPlaying(1),
            builder: (BuildContext c, AsyncSnapshot s) {
              if (s.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return new MovieList(
                  playing: s.data,
                  key: UniqueKey(),
                );
            },
          ),
        ));
  }
}

class MovieList extends StatefulWidget {
  final Playing playing;
  const MovieList({
    required this.playing,
    required Key key,
  }) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  ScrollController scrollController = new ScrollController();
  late List<Result> movie;
  int currentPage = 1;

  bool onNotificatin(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        print('End Scroll');
        MovieRepository().getNowPlaying(currentPage + 1).then((val) {
          currentPage = val.page!;
          setState(() {
            movie.addAll(val.results!);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    movie = widget.playing.results!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotificatin,
      child: ListView.builder(
          itemCount: movie.length,
          controller: scrollController,
          itemBuilder: (BuildContext c, int i) {
            return Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: 300.0,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  image: DecorationImage(
                      image: NetworkImage('https://image.tmdb.org/t/p/w500' +
                          movie[i].posterPath!),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie[i].title!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(movie[i].voteAverage.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton.icon(
                        color: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        onPressed: () {},
                        label: Text('Voir Details'),
                        icon: Icon(Icons.keyboard_arrow_right),
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
