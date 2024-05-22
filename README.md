# Flutter Google Sheets App

This Flutter project allows adding and deleting data from a Google Sheets spreadsheet. It is a simple and functional example of how to integrate a Flutter application with the Google Sheets API using the `gsheets` package.

## Features

- Add data to the Google Sheets spreadsheet
- Delete data from the Google Sheets spreadsheet

## Technologies Used

- [Flutter](https://flutter.dev/)
- [Google Sheets API](https://developers.google.com/sheets/api)
- [HTTP](https://pub.dev/packages/http) - for making HTTP requests
- [Gsheets](https://pub.dev/packages/gsheets) - for simplified interaction with Google Sheets

## Prerequisites

Before you begin, make sure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Google Cloud account with Google Sheets API enabled
- Google Sheets API credentials

## Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/daniloasdotcom/flutter_gsheets.git
    cd flutter_gsheets
    ```

2. Install the dependencies:
    ```bash
    flutter pub get
    ```

3. Set up your Google Sheets API credentials:
    - Create a project in the [Google Cloud Console](https://console.cloud.google.com/)
    - Enable the Google Sheets API
    - Generate OAuth 2.0 credentials and save the `credentials.json` file in the root of your project

4. Configure the spreadsheet ID:
    - Open the `lib/googlesheets.dart` file and add the ID of your Google Sheets spreadsheet

5. Run the application:
    ```bash
    flutter run
    ```

## Usage

### Add Data

1. Fill in the necessary fields in the add data form.
2. Click the "Add" button to send the data to the spreadsheet.

### Delete Data

1. Select the item you want to delete.
2. Click the "Delete" button to remove the data from the spreadsheet.

## Contribution

Contributions are welcome! Feel free to open an `issue` or submit a `pull request`.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Danilo A. Santos - [danilo_as@live.com](mailto:danilo_as@live.com)

Project Link: [https://github.com/daniloasdotcom/flutter_gsheets](https://github.com/daniloasdotcom/flutter_gsheets)
