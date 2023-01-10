import 'dart:async';

void main() {
  streamClassicDoubleSubscriptionAwait();
}

void streamClassicDoubleSubscriptionAwait() {
  Stream<int> stream;

  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10).asBroadcastStream();

  Future<void> listen1() async {
    await for (var i in stream) {
      print(i);
    }
  }

  Future<void> listen2() async {
    await for (var i in stream) {
      print(i);
    }
  }

  listen1();
  listen2();
}

void streamClassicDoubleSubscription() {
  Stream<int> stream;
  StreamSubscription sub;
  StreamSubscription sub2;
  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10);
  stream = stream.asBroadcastStream();
  sub = stream.listen((event) {
    print(event);
  });
  sub2 = stream.listen((event) {
    print(event);
  });
  Future.delayed(
    Duration(seconds: 5),
    () {
      sub.cancel();
      sub2.cancel();
    },
  );
}

void streamClassicSubscription() {
  Stream<int> stream;
  Stream<String> stream2;
  StreamSubscription sub;
  StreamSubscription sub2;

  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10);
  stream2 = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => '$computationCount --',
  ).take(20);
  sub = stream.listen((event) {
    print(event);
  });
  sub2 = stream2.listen((event) {
    print(event);
  });
  Future.delayed(
    Duration(seconds: 3),
    () => sub.pause(),
  );
  Future.delayed(
    Duration(seconds: 5),
    () => sub.resume(),
  );
  Future.delayed(
    Duration(seconds: 7),
    () {
      sub.cancel();
      sub2.cancel();
    },
  );
}
