# 🎬 Filmes Ília - Flutter Code Challenge

**English**

Filmes Ília is a Flutter-based mobile application that showcases movies currently playing in theaters using TheMovieDB API. The app allows users to browse movies, view detailed information about each movie, search by title, and even watch trailers directly within the app.

## 🚀 Features
### Core Features
- Movie Listing: Display a list of movies currently playing in theaters.
- Movie Details: View detailed information about a selected movie, including its synopsis, genres, and rating.

### Extra Features
- Infinite Scrolling: Automatically load more movies as the user scrolls down the list.
- Movie Trailer: Watch movie trailers directly from the detail screen.
- Search Functionality: Search for movies by title on the main screen
- Data Caching: Movie details are cached so that they can be accessed even without an internet connection.

## 🛠️ Project Structure

The project is structured using the MVVM (Model-View-ViewModel) architecture pattern, making it scalable and easy to maintain. State management is handled using Riverpod, providing a clean separation of UI and business logic.

```
lib/
├── common/
│   ├── entities/                 # Contains common entities like failure models
│   └── utils/                    # Utility classes (e.g., FormatUtils)
├── features/
│   └── now_playing/
│       ├── api/                  # Contains API clients and services
│       ├── data/
│       │   └── models/           # Data models (e.g., MovieModel, MovieDetail)
│       ├── presentation/
│       │   ├── pages/            # Pages (e.g., MovieListPage, MovieDetailPage)
│       │   ├── viewmodels/       # ViewModels for managing UI state
│       │   └── widgets/          # Reusable UI components (e.g., MovieTile, SearchBox)
│       └── providers/            # Riverpod providers 
└── main.dart                     # Entry point of the application
```

## 🧩 Libraries used:
- `dio`: For handling requests to the API
- `flutter_dotenv`: For injecting the API key into the application
- `dartz`: For functional programming and the usage of Either<L,R>
- `youtube_player_flutter`: For playing the trailers 
- `flutter_riverpod`: Riverpod was chosen as the state management library
- `hive` and `hive_flutter`: Hive was used for caching 
- `mockito`: For testing with dependency injection
- `intl`: For formatting currencies

## 🛠️ Setup and Installation

My machine's configuration while building this project is:

```
Flutter 3.10.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f468f3366c (1 year, 1 month ago) • 2023-07-12 15:19:05 -0700
Engine • revision cdbeda788a
Tools • Dart 3.0.6 • DevTools 2.23.1
```

### Installation

### 1. Clone the repository:

```bash
git clone github.com/raphasauer/ilia-flutter-challenge.git
cd ilia-flutter-challenge
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Create a `.env` file

This step is very important. Since API keys should be kept private, this code loads a `.env` file that should be written as follows:

```
API_KEY=your_key_here
```

This file is not on version control.

The path expected for the `.env` file is on the root of the project. If this path is altered it is necessary to alter the path on `pubspec.yaml` as well.

### 4. Build the Hive adapters

Hive is a NoSql database that was used for caching information about a movie details. It can serialize and deserialize objects to store them. However, for more complex objects that use data structures that are not primitives (such as the `MovieDetailModel`), they require the use of `hive_generator` via the `build_runner` development dependency:

```bash
flutter packages pub run build_runner build
```

This will also build the mock classes necessary for the tests.

### 5. Run the application

```bash
flutter run
```

# 🧪 Testing

This application features unit tests for the viewmodels, the services and the utils. They use dependency injection when possible, using the `mockito` package. To run the tests:

```bash
flutter test
```

**Portuguese**

# 🎬 Filmes Ília - Desafio de Flutter

Filmes Ília é um aplicativo móvel baseado em Flutter que exibe filmes atualmente em cartaz nos cinemas utilizando a API do TheMovieDB. O aplicativo permite que os usuários naveguem pelos filmes, visualizem informações detalhadas sobre cada filme, façam buscas por título e até assistam a trailers diretamente no aplicativo.

## 🚀 Funcionalidades
### Funcionalidades básicas
- Listagem de Filmes: Exibe uma lista de filmes que estão em cartaz nos cinemas.
- Detalhes do Filme: Visualize informações detalhadas sobre um filme selecionado, incluindo sua sinopse, gêneros e avaliação.

### Funcionalidades extra
- Scroll Infinito: Carregue mais filmes automaticamente conforme o usuário rola a lista para baixo.
- Trailer do Filme: Assista aos trailers dos filmes diretamente na tela de detalhes.
- Funcionalidade de Busca: Busque filmes por título na tela principal.
- Cache de Dados: Os detalhes dos filmes são armazenados em cache para que possam ser acessados mesmo sem conexão à internet.

## 🛠️ Estrutura do projeto

O projeto é estruturado utilizando o padrão de arquitetura MVVM (Model-View-ViewModel), tornando-o escalável e fácil de manter. O gerenciamento de estado é realizado utilizando o Riverpod, proporcionando uma separação clara entre a interface do usuário e a lógica de negócios.

```
lib/
├── common/
│   ├── entities/                 # Contém entidades como as failures
│   └── utils/                    # Classes de utilitários (como o FormatUtils)
├── features/
│   └── now_playing/
│       ├── api/                  # Contém o client da API e os serviços
│       ├── data/
│       │   └── models/           # Modelos de dados (como MovieModel, MovieDetail)
│       ├── presentation/
│       │   ├── pages/            # Páginas (como MovieListPage, MovieDetailPage)
│       │   ├── viewmodels/       # ViewModels para gerenciar os estados da UI
│       │   └── widgets/          # Componentes reutilizáveis para interface gráfica (como MovieTile, SearchBox)
│       └── providers/            # Providers para o riverpod 
└── main.dart                     # Ponto de entrada do applicativo
```

## 🧩 Bibliotecas utilizadas:
- `dio`: Para enviar requests à API
- `flutter_dotenv`: Para injeção da chave de API no código
- `dartz`: Para programação funcional e o uso do Either<L,R>
- `youtube_player_flutter`: Para reproduzir trailers do YouTube
- `flutter_riverpod`: Riverpod foi o sistema de gerenciamento de estados escolhido
- `hive` and `hive_flutter`: Hive foi utilizado para o cacheamento
- `mockito`: Para testes com injeção de dependência
- `intl`: Para formatação de moedas

## 🛠️ Setup e Instalação

A configuração de minha máquina de desenvolvimento é:

```
Flutter 3.10.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f468f3366c (1 year, 1 month ago) • 2023-07-12 15:19:05 -0700
Engine • revision cdbeda788a
Tools • Dart 3.0.6 • DevTools 2.23.1
```

### Instalação

### 1. Clonar o repositório:

```bash
git clone github.com/raphasauer/ilia-flutter-challenge.git
cd ilia-flutter-challenge
```

### 2. Instalar dependências

```bash
flutter pub get
```

### 3. Criar o arquivo `.env`

Esse passo é muito importante. Chaves de APIs devem ser mantidas em segredo, por isso esse código carrega um `.env` que deve possuir os seguintes campos:
```
API_KEY=sua_chave_aqui
```

Esse arquivo não está no versionamento de arquivos.

O path esperado para o arquivo `.env` é na raiz do projeto. Caso queira alterar o caminho, é necessário alterar também o `pubspec.yaml`.

### 4. Build dos adpaters do Hive

O Hive é um banco de dados NoSql que foi usado para o cacheamento dos detalhes dos filmes. Ele consegue serializar e deserializar objetos para armazenamento. Porém, para objetos que contém estruturas de dados não primitivas (como o `MovieDetailModel`), requerem o uso do `hive_generator` via `build_runner`:

```bash
flutter packages pub run build_runner build
```

Esse passo também gera as classes de mock para os testes.

### 5. Rodando o aplicativo

```bash
flutter run
```

# 🧪 Testes

Essa aplicação possui testes unitários para os viewmodels, serviços e utilidades. Eles usam injeção de dependência via `mockito`. Para rodar os testes:
```bash
flutter test
```


