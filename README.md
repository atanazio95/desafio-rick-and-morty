````markdown
# Rick and Morty App

Este projeto é um aplicativo mobile desenvolvido em **Flutter**, que consome a **API pública de Rick and Morty**.  
Ele permite aos usuários explorar o universo da série, visualizando uma lista completa de personagens, seus detalhes e gerenciando uma lista de favoritos que pode ser acessada offline.

---

## 🚀 Como rodar o projeto

### 🔧 Requisitos de instalação
Certifique-se de ter as seguintes versões instaladas:

- **Flutter:** 3.35.3  
- **Dart:** 3.9.2  
- **Ambiente de Desenvolvimento:** Android Studio (ou outra IDE como VS Code) com o plugin do Flutter instalado.

---

### 📥 Clone o repositório
```bash
git clone https://github.com/atanazio95/desafio-rick-and-morty
````

Acesse a pasta do projeto:

```bash
cd desafio-rick-and-morty
```

---

### 📦 Instale as dependências

```bash
flutter pub get
```

---

### ▶️ Execute o aplicativo

Conecte um dispositivo físico ou inicie um emulador e rode:

```bash
flutter run
```

---

## 🛠️ Escolhas Técnicas

### Arquitetura

O projeto foi construído seguindo os princípios da **Clean Architecture (Arquitetura Limpa)**.
Essa abordagem separa a lógica de negócio (camada de domínio) das camadas de apresentação e dados, tornando o código mais **escalável, testável e de fácil manutenção**.

O uso de **UseCases** foi mantido para aderência ao padrão, embora a comunidade Flutter esteja em movimento de simplificação, considerando-os redundantes em alguns cenários.

---

### Estrutura de Pastas

O projeto segue uma estrutura modular, onde cada **feature** possui suas próprias camadas.

```bash
lib
├── core
│   └── error          # Classes de erro globais
│
└── features
    └── rick-and-morty
        ├── domain      # Lógica de negócio (entidades, casos de uso, interfaces)
        ├── data        # Implementação de dados (repositórios, fontes de dados, modelos)
        └── presentation# Interface do usuário (páginas, widgets, provedores de estado)
```

---

### Gerenciamento de Estado

Foi utilizado o **Riverpod**, que é uma biblioteca robusta e segura para **injeção de dependência** e **gerenciamento de estado**, facilitando o fluxo de dados entre as camadas.

---

### Comunicação com a API

A comunicação com a **API de Rick and Morty** foi feita com a biblioteca **Dio**, que oferece:

* Interface flexível
* Configuração de **timeouts**
* Suporte a **interceptadores**

---

### Persistência de Dados

A lista de favoritos é salva localmente usando o **Hive**, um banco de dados **NoSQL leve e rápido**, ideal para o Flutter.

> **Obs:** As imagens não são salvas localmente. Essa decisão foi tomada para priorizar **performance** e análise de ferramentas adequadas dentro do tempo de desenvolvimento.

---

## 🧪 Testes

O projeto conta com **testes unitários** e **widget tests**, garantindo maior confiabilidade e aderência aos princípios da Clean Architecture.

### ▶️ Como rodar os testes

Para executar todos os testes:

```bash
flutter test
```

Para rodar apenas um arquivo específico:

```bash
flutter test test/features/rick_and_morty/character_list_notifier_test.dart
```

### 📂 Estrutura dos testes

* **Unit Tests**: validam a lógica de negócio e os casos de uso.
* **Widget Tests**: garantem que a interface do usuário renderize corretamente e responda às interações.
* **Mocks**: criados com **Mockito** ou **Mocktail** para simular dependências externas como repositórios e fontes de dados.

---

## 📚 Tecnologias Utilizadas

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [Riverpod](https://riverpod.dev/)
* [Dio](https://pub.dev/packages/dio)
* [Hive](https://pub.dev/packages/hive)
* [Mockito](https://pub.dev/packages/mockito) / [Mocktail](https://pub.dev/packages/mocktail)

---

## 📌 Metodologia de Trabalho

Durante o desenvolvimento, foi utilizada a metodologia **Scrum**, com organização e acompanhamento das tarefas através de um **quadro no Trello**:

👉 [Quadro no Trello - Desafio Way Data](https://trello.com/b/ca279MDd/desafio-way-data)

---

## 👨‍💻 Autor

Desenvolvido por **[Jeorge Atanazio](https://github.com/atanazio95)** 🚀


