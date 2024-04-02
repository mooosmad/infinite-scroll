import 'package:flutter/material.dart';
import 'package:iscroll/data/api.dart';
import 'package:iscroll/model/lecture.dart';

class ShikasmaduPlay extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<ShikasmaduPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'ShikasmaduTv',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
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
            if (s.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (s.hasError) {
              return Center(
                child: Text('Error: ${s.error}'),
              );
            } else {
              return new MovieList(
                playing: s.data,
                key: UniqueKey(),
              );
            }
          },
        ),
      ),
    );
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

  bool onNotification(ScrollNotification notification) {
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

  void navigateToDetails(BuildContext context, Result movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: ListView.builder(
        itemCount: movie.length,
        controller: scrollController,
        itemBuilder: (BuildContext c, int i) {
          return GestureDetector(
            onTap: () => navigateToDetails(context, movie[i]),
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.orange,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500' + movie[i].posterPath!),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie[i].title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          movie[i].voteAverage.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Text('Voir Détails'),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  final Result movie;

  const MovieDetailsPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: 'movie_poster_${movie.id}',
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500' + movie.posterPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              elevation: 0.0,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Note: ${movie.voteAverage}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie.overview!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
