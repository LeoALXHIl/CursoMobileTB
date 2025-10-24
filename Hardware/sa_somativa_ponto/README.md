# Aplicativo de Registro de Ponto de Funcionários

Um aplicativo Flutter completo desenvolvido para rastreamento de presença de funcionários utilizando **geolocalização**, **autenticação biométrica** e **integração com Firebase**.
O app garante check-ins seguros e verificados por localização, oferecendo uma interface amigável com **animações envolventes**.

## Funcionalidades

* **Autenticação Segura**: Login usando o NIF (Número de Identificação Fiscal) e senha, com suporte opcional a biometria (reconhecimento facial) para maior segurança.
* **Check-In por Geolocalização**: Os funcionários só podem realizar check-ins se estiverem dentro de um raio definido (padrão: 500 metros) do local de trabalho.
* **Feedback em Tempo Real**: Mensagens de status dinâmicas e animações fornecem retorno imediato durante o processo de check-in.
* **Histórico de Check-Ins**: Visualize um histórico detalhado dos check-ins anteriores, incluindo data, hora, localização e status de validação.
* **Integração com Firebase**: Utiliza Firebase Authentication para gerenciamento de usuários e Firestore para armazenamento dos dados de check-in.
* **Animações Interativas**: Inclui animação de “bounce” (salto) no ícone principal com efeito de brilho (*shimmer*), animação de “pulso” no cartão de check-in e confete ao realizar check-ins bem-sucedidos.
* **Design Responsivo**: Otimizado para diversos tamanhos de tela, com fundos em degradê e transições suaves.
* **Suporte Biométrico**: Integra a biometria do dispositivo para acesso rápido e seguro.

## Arquitetura

O aplicativo segue um padrão de arquitetura limpa inspirado no **MVC (Model-View-Controller)**, separando responsabilidades para facilitar manutenção e escalabilidade:

* **Models** (`lib/model/`): Estruturas de dados para as entidades *User* e *CheckIn*, incluindo métodos de serialização para o Firestore.
* **Controllers** (`lib/controller/`): Camada de lógica de negócio responsável por autenticação, serviços de localização e biometria.
* **Views** (`lib/view/`): Componentes de interface de usuário, como HomeScreen, HistoryScreen e LoginScreen.
* **Main Entry** (`lib/main.dart`): Inicialização do app, configuração de tema e rotas.

### Componentes Principais

* **AuthController**: Gerencia a autenticação com Firebase, incluindo login, logout e integração biométrica.
* **LocationController**: Lida com permissões de geolocalização, obtenção de posição e cálculo de distância até o local de trabalho.
* **BiometricController**: Interface com os recursos biométricos do dispositivo.
* **HomeScreen**: Tela principal com animações, lógica de check-in e mensagens de status.
* **HistoryScreen**: Exibe a lista de check-ins do usuário armazenados no Firestore.
* **LoginScreen**: Gerencia o processo de autenticação com validação de formulário e opções biométricas.

## Instalação

1. **Pré-requisitos**:

   * Flutter SDK (versão 3.0 ou superior)
   * Android Studio ou VS Code com extensões Flutter
   * Um projeto no Firebase

2. **Clonar o Repositório**:

   ```bash
   git clone <repository-url>
   cd sa_somativa_ponto
   ```

3. **Instalar Dependências**:

   ```bash
   flutter pub get
   ```

4. **Configurar Firebase**:

   * Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
   * Ative a autenticação por **Email/Senha** e o **Firestore**.
   * Para Android: baixe o arquivo `google-services.json` e coloque em `android/app/`.
   * Para iOS: baixe o arquivo `GoogleService-Info.plist` e coloque em `ios/Runner/`.
   * Atualize `lib/firebase_options.dart` com sua configuração Firebase (use `flutterfire configure` para gerar automaticamente).

5. **Executar o App**:

   ```bash
   flutter run
   ```

## Permissões

O aplicativo requer as seguintes permissões para funcionamento completo:

* **Acesso à Localização**: Permissões de localização precisa e aproximada para verificar a proximidade do local de trabalho.
* **Acesso Biométrico**: Acesso à câmera para reconhecimento facial (opcional; usa senha como alternativa).

Certifique-se de conceder as permissões durante a execução ou nas configurações do dispositivo.

## Uso

1. **Iniciar o App**: Abra o aplicativo e vá até a tela de login.
2. **Autenticar-se**:

   * Insira seu NIF e senha.
   * Opcionalmente, habilite a autenticação biométrica para logins futuros.
3. **Realizar Check-In**:

   * Na tela inicial, toque em **“Fazer Check-In”**.
   * O app solicitará permissão de localização e verificará sua posição.
   * Se estiver dentro do raio permitido, o check-in será salvo no Firestore, exibindo as animações de sucesso.
4. **Ver Histórico**: Toque no ícone de histórico na barra superior para visualizar check-ins anteriores.
5. **Sair**: Use o botão de logout para encerrar a sessão.

### Configuração do Local de Trabalho

O local padrão é **Limeira, Brasil** (latitude: -23.5505, longitude: -46.6333).
Para personalizar:

```dart
static const double workplaceLatitude = --22.5708; // Sua latitude
static const double workplaceLongitude = -47.4039; // Sua longitude
```

O raio pode ser ajustado no método `HomeScreen._checkIn()` (atualmente 500 metros).

## Estrutura do Código

```
lib/
├── controller/
│   ├── auth_controller.dart          # Lógica de autenticação e biometria com Firebase
│   ├── biometric_controller.dart     # Manipulação de autenticação biométrica
│   └── location_controller.dart      # Geolocalização e cálculos de distância
├── model/
│   ├── checkin.dart                  # Modelo de CheckIn com serialização para Firestore
│   └── user.dart                     # Modelo de Usuário (opcionalmente estendido)
├── view/
│   ├── history_screen.dart           # Interface do histórico de check-ins
│   ├── home_screen.dart              # Tela principal de check-in com animações
│   └── login_screen.dart             # Tela de autenticação
├── main.dart                         # Ponto de entrada e rotas do app
└── firebase_options.dart             # Configuração Firebase

test/
├── auth_controller_test.dart         # Testes unitários de AuthController
├── location_controller_test.dart     # Testes unitários de LocationController
└── integration_test/
    └── app_test.dart                 # Testes de integração do fluxo completo

android/                              # Configurações específicas do Android
ios/                                  # Configurações específicas do iOS
```

### Detalhes das Animações

A **HomeScreen** contém várias animações para tornar a experiência mais agradável:

* **Animação Bounce**: Aplicada ao ícone principal usando `AnimatedBuilder` e `Transform.scale`. Repete indefinidamente com curva elástica, combinada com efeito *shimmer*.
* **Animação Pulse**: Envolve o cartão de check-in, aumentando e diminuindo levemente de tamanho.
* **Transições Fade e Slide**: As mensagens de status aparecem/desaparecem suavemente e as informações de localização deslizam na tela.
* **Animação de Escala**: Efeito visual ao pressionar botões.
* **Confete**: Ativado em check-ins bem-sucedidos, usando o pacote `confetti` para partículas comemorativas.

Todos os controladores de animação são devidamente descartados em `dispose()` para evitar vazamentos de memória.

## Testes

### Testes Unitários

Execute testes específicos de controladores:

```bash
flutter test test/auth_controller_test.dart
flutter test test/location_controller_test.dart
```

### Testes de Integração

Testa o fluxo completo do app (UI e lógica):

```bash
flutter test integration_test/app_test.dart
```

> Para testes mais completos, simule serviços do Firebase e de localização com ferramentas como `mockito`.

### Checklist de Teste Manual

* Verifique se as animações funcionam em diferentes dispositivos.
* Teste o check-in com locais simulados dentro e fora do raio permitido.
* Confirme o funcionamento do login biométrico.
* Verifique a persistência e leitura de dados no Firestore.

## Dependências

Principais pacotes usados (`pubspec.yaml`):

* `firebase_core`: Funcionalidades principais do Firebase.
* `firebase_auth`: Autenticação de usuários.
* `cloud_firestore`: Banco de dados NoSQL para check-ins.
* `geolocator`: Serviços de GPS.
* `local_auth`: Autenticação biométrica.
* `confetti`: Animações de partículas.
* `shimmer`: Efeitos de carregamento e brilho.
* `provider`: Gerenciamento de estado (para futuras expansões).

Lista completa disponível em `pubspec.yaml`.

## Contribuindo

1. Faça um **fork** do repositório.
2. Crie uma **branch** de recurso:

   ```bash
   git checkout -b feature/nova-funcionalidade
   ```
3. Faça seus commits:

   ```bash
   git commit -am 'Adiciona nova funcionalidade'
   ```
4. Envie a branch:

   ```bash
   git push origin feature/nova-funcionalidade
   ```
5. Abra um **Pull Request** com uma descrição detalhada das alterações.

### Estilo de Código

* Siga o guia oficial de estilo do Dart.
* Use nomes de variáveis significativos e comente trechos complexos.
* Garanta que todo novo código tenha testes unitários.




---

