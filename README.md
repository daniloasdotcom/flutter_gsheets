# Flutter Google Sheets App

Este projeto Flutter permite adicionar e deletar dados de uma planilha do Google Sheets. É um exemplo simples e funcional de como integrar um aplicativo Flutter com a API do Google Sheets utilizando o pacote `gsheets`.

## Funcionalidades

- Adicionar dados à planilha do Google Sheets
- Deletar dados da planilha do Google Sheets

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Google Sheets API](https://developers.google.com/sheets/api)
- [HTTP](https://pub.dev/packages/http) - para realizar requisições HTTP
- [Gsheets](https://pub.dev/packages/gsheets) - para interação simplificada com o Google Sheets

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes itens instalados:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Conta no Google Cloud com a API do Google Sheets habilitada
- Credenciais da API do Google Sheets

## Instalação

1. Clone este repositório:
    ```bash
    git clone https://github.com/daniloasdotcom/flutter_gsheets.git
    cd flutter_gsheets
    ```

2. Instale as dependências:
    ```bash
    flutter pub get
    ```

3. Configure suas credenciais da API do Google Sheets:
    - Crie um projeto no [Google Cloud Console](https://console.cloud.google.com/)
    - Habilite a API do Google Sheets
    - Gere as credenciais de OAuth 2.0 e salve o arquivo `credentials.json` na raiz do seu projeto

4. Configure o ID da planilha:
    - Abra o arquivo `lib/constants.dart` e adicione o ID da sua planilha do Google Sheets

5. Execute o aplicativo:
    ```bash
    flutter run
    ```

## Uso

### Adicionar Dados

1. Preencha os campos necessários no formulário de adição de dados.
2. Clique no botão "Adicionar" para enviar os dados para a planilha.

### Deletar Dados

1. Selecione o item que deseja deletar.
2. Clique no botão "Deletar" para remover os dados da planilha.

## Estrutura do Projeto

- `lib/`
  - `main.dart` - Ponto de entrada do aplicativo
  - `screens/` - Telas do aplicativo
    - `home_screen.dart` - Tela principal com opções para adicionar e deletar dados
  - `services/` - Serviços de integração com a API do Google Sheets
    - `google_sheets_service.dart` - Serviço para comunicação com a API do Google Sheets
  - `widgets/` - Widgets reutilizáveis do aplicativo
  - `constants.dart` - Constantes utilizadas no aplicativo, como ID da planilha e URLs da API

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir um `issue` ou enviar um `pull request`.

1. Fork o repositório
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Faça o push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

## Contato

Danilo A. Santos - [danilo_as@live.com](mailto:danilo_as@live.com)

Link do Projeto: [https://github.com/daniloasdotcom/flutter_gsheets](https://github.com/daniloasdotcom/flutter_gsheets)
