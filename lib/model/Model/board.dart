class Board {
  final String text;
  final String image;
  Board({this.text, this.image});
}

List<Board> boardScreen = [
  Board(
      image: 'assets/BoardImages/no_more.png',
      text: 'welcome to Devine your online store ....'),
  Board(
      image: 'assets/BoardImages/welcome.png',
      text:
          'During this period of Covid where movement is restricted ! ..we here for you'),
  Board(
    image: 'assets/BoardImages/sign_in.png',
    text: ' worried about privacy and online transaction ... we here for you !',
  ),
  Board(
    image: 'assets/BoardImages/confirm.png',
    text: 'Easily Check your cart and get an instant approval',
  ),
  Board(
    image: 'assets/BoardImages/arrived.png',
    text: 'Delivery takes no time !',
  ),
];
