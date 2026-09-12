# Connection Manager (`--cm`) — архитектурные диаграммы

> Документ описывает **Connection Manager (CM)** — UI на стороне **контролируемого хоста** (машина, к которой подключаются).
> Источник: [rustdesk/rustdesk](https://github.com/rustdesk/rustdesk) — `flutter/lib/desktop/pages/server_page.dart`, `flutter/lib/models/server_model.dart`, `flutter/lib/main.dart`.

---

## 1. Роль CM в системе

Connection Manager — **отдельный процесс/окно**, запускаемый флагом `--cm`. Он появляется, когда удалённый клиент пытается подключиться к этой машине, и позволяет пользователю:

- увидеть входящее подключение;
- **авторизовать** или **отклонить** сессию;
- управлять **разрешениями** (клавиатура, буфер обмена, файлы, аудио, запись);
- обмениваться **чатом** и **голосовыми вызовами**;
- закрыть или отключить клиента.

```mermaid
flowchart LR
    subgraph Remote["Удалённый клиент"]
        RC["RustDesk Client\n(исходящее подключение)"]
    end

    subgraph Host["Контролируемый хост"]
        RS["Rust Server\n(server connection handler)"]
        IPC["IPC канал"]
        CM["CM процесс\n--cm"]
        UI["Flutter CM Window\nDesktopServerPage"]
    end

    RC -->|"NAT / Relay"| RS
    RS -->|"сигнал: новое подключение"| IPC
    IPC --> CM
    CM --> UI
    UI -->|"authorize / close / permissions"| CM
    CM -->|"FFI команды"| RS
```

---

## 2. Точки входа и жизненный цикл процесса

```mermaid
flowchart TB
    Start(["Запуск rustdesk"]) --> ParseArgs{"Аргументы CLI"}

    ParseArgs -->|"args пустые"| MainApp["runMainApp()\nDesktopType.main\nГлавное окно"]
    ParseArgs -->|"multi_window"| MultiWin["runMultiWindow()\nRemote / FileTransfer / ..."]
    ParseArgs -->|"--cm"| CMEntry["runConnectionManagerScreen()\nDesktopType.cm"]
    ParseArgs -->|"--install"| Install["runInstallPage()"]

    CMEntry --> InitEnv["initEnv(kAppTypeConnectionManager)\nplatformFFI + global FFI"]
    InitEnv --> RunApp["_runApp('', DesktopServerPage())"]
    RunApp --> HideCheck{"hide_cm == true?"}

    HideCheck -->|да| HideWin["hideCmWindow()\nopacity=0, minimize"]
    HideCheck -->|нет| ShowWin["showCmWindow()\nправый верхний угол"]

    ShowWin --> TimerLoop["ServerModel: Timer 500ms"]
    HideWin --> TimerLoop

    TimerLoop --> ClientsEmpty{"clients.isEmpty?"}
    ClientsEmpty -->|да, 6 сек| CloseWin["windowManager.close()"]
    ClientsEmpty -->|нет| ShowCM["showCmWindow()"]
```

| Параметр | Значение |
|---|---|
| CLI-флаг | `--cm` |
| `DesktopType` | `DesktopType.cm` |
| App type | `kAppTypeConnectionManager` |
| Root widget | `DesktopServerPage` |
| Окно | Отдельное (не `desktop_multi_window`, а **отдельный процесс**) |
| Размер окна | `kConnectionManagerWindowSizeClosedChat` |
| Позиция | `Alignment.topRight` |

---

## 3. Иерархия виджетов (Presentation)

```mermaid
flowchart TB
    subgraph CMWindow["CM Window (--cm)"]
        DSP["DesktopServerPage\n(StatefulWidget + WindowListener)"]

        subgraph Providers["MultiProvider"]
            SM["ServerModel\nChangeNotifier"]
            CM2["ChatModel\nChangeNotifier"]
        end

        DSP --> Providers
        DSP --> CMWidget["ConnectionManager\n(StatefulWidget)"]

        CMWidget --> Empty{"clients.isEmpty?"}

        Empty -->|да| Waiting["TitleBar + Text('Waiting')"]
        Empty -->|нет| TabView["DesktopTab\n(tabType: cm)"]

        TabView --> TabPerClient["Tab на каждого Client\nkey = client.id"]

        TabPerClient --> ClientPanel["ClientPanel\n(контент вкладки)"]

        ClientPanel --> AuthBlock["Authorize / Reject\n(если !authorized)"]
        ClientPanel --> PermBlock["Permission toggles\nkeyboard, clipboard, file, audio, ..."]
        ClientPanel --> Actions["Close / Elevate / Block input"]
        ClientPanel --> SidePanel["Side panel\nChat overlay, file jobs"]

        SidePanel --> ChatOverlay["DraggableChatWindow\n→ ChatPage"]
        SidePanel --> CmFileModel["CmFileModel\nфайловые job'ы CM"]
    end
```

### Поведение при закрытии окна

```mermaid
sequenceDiagram
    participant User as Пользователь
    participant WM as window_manager
    participant DSP as DesktopServerPage
    participant SM as ServerModel
    participant FFI as gFFI / Rust

    User->>WM: закрыть окно CM
    WM->>DSP: onWindowClose()
    DSP->>SM: closeAll()
    DSP->>FFI: close()
    alt macOS
        DSP->>DSP: RdPlatformChannel.terminate()
    else Windows / Linux
        DSP->>WM: setPreventClose(false) + close()
    end
```

---

## 4. Модель данных

### 4.1 ServerModel — центральное состояние CM

```mermaid
classDiagram
    class ServerModel {
        +List~Client~ clients
        +DesktopTabController tabController
        +int connectStatus
        +String verificationMethod
        +String approveMode
        +bool hideCm
        +Timer cmHiddenTimer
        +bool showElevation
        +updateClientState()
        +closeAll()
        +timerCallback() 500ms
    }

    class Client {
        +int id
        +String peerId
        +String name
        +bool authorized
        +bool keyboard
        +bool clipboard
        +bool audio
        +bool file
        +bool restart
        +bool recording
        +bool blockInput
        +bool isFileTransfer
        +bool isViewCamera
        +bool isTerminal
        +String portForward
        +bool disconnected
        +RxInt unreadChatMessageCount
        +type() ConnectionType
    }

    class DesktopTabController {
        +DesktopTabType.cm
        +add(TabInfo)
        +remove(int)
        +onSelected callback
        +onRemoved callback
    }

    class ChatModel {
        +bool isConnManager
        +MessageKey currentKey
        +showChatWindowOverlay()
        +send(message)
    }

    ServerModel "1" --> "*" Client : clients
    ServerModel --> DesktopTabController : tabController
    DesktopServerPage --> ServerModel
    DesktopServerPage --> ChatModel
    ConnectionManager --> DesktopTabController
```

### 4.2 Client — типы входящих подключений

```mermaid
flowchart TD
    Client["Client (входящее подключение)"] --> TypeCheck{"type()"}

    TypeCheck -->|isFileTransfer| FT["File Transfer"]
    TypeCheck -->|isViewCamera| VC["View Camera"]
    TypeCheck -->|isTerminal| TM["Terminal"]
    TypeCheck -->|portForward != ''| PF["Port Forward"]
    TypeCheck -->|иначе| RD["Remote Desktop"]

    FT & VC & TM & PF & RD --> Tab["Отдельная вкладка\nв DesktopTab (CM)"]
```

---

## 5. Поток входящего подключения

```mermaid
sequenceDiagram
    autonumber
    participant Remote as Удалённый клиент
    participant Rust as Rust Server Handler
    participant IPC as IPC (ui_cm_interface)
    participant FFI as platformFFI / bind
    participant SM as ServerModel
    participant UI as ConnectionManager UI

    Remote->>Rust: запрос подключения
    Rust->>IPC: addConnection(id, peerId, flags, permissions...)
    IPC->>FFI: event → Flutter
    FFI->>SM: updateClientState(json)
    SM->>SM: Client.fromJson() → clients.add()
    SM->>SM: tabController.add(TabInfo)
    SM->>UI: notifyListeners()

    alt authorized == false
        UI->>UI: показать Authorize / Reject
        UI->>User: ожидание решения
        User->>UI: Authorize
        UI->>FFI: bind.cmAuthorize(id)
        FFI->>Rust: authorize connection
    else authorized == true (auto)
        UI->>UI: auto-minimize через 3s
    end

    loop Timer 500ms
        SM->>FFI: cmCheckClientsLength(clients.length)
        alt списки расходятся
            FFI->>SM: resync JSON
            SM->>SM: updateClientState(res)
        end
    end
```

---

## 6. Действия пользователя в CM

```mermaid
flowchart LR
    subgraph UserActions["Действия пользователя"]
        A1["Authorize"]
        A2["Reject / Close"]
        A3["Toggle permission\n(keyboard, clipboard, file, audio)"]
        A4["Send chat message"]
        A5["Elevate (portable)"]
        A6["Block input"]
        A7["Switch tab (Client)"]
    end

    subgraph FFI["FFI → Rust"]
        F1["cmAuthorize(id)"]
        F2["cmClose(id)"]
        F3["cmSwitchPermission(id, name, enabled)"]
        F4["cmSendChat(id, text)"]
        F5["cmElevatePortable(id)"]
        F6["cmSwitchPermission block_input"]
    end

    subgraph SideEffects["Побочные эффекты UI"]
        S1["client.authorized = true"]
        S2["tabController.remove(id)\n→ onRemoveId → close window"]
        S3["обновление toggles в ClientPanel"]
        S4["ChatModel.send → overlay"]
        S5["showElevation button"]
        S6["windowManager.setTitle(peerId)"]
    end

    A1 --> F1 --> S1
    A2 --> F2 --> S2
    A3 --> F3 --> S3
    A4 --> F4 --> S4
    A5 --> F5 --> S5
    A6 --> F6 --> S3
    A7 --> S6
```

### Переключение вкладки (onSelected)

```mermaid
sequenceDiagram
    participant Tab as DesktopTab
    participant CM as ConnectionManagerState
    participant Chat as ChatModel
    participant File as CmFileModel
    participant WM as window_manager

    Tab->>CM: onSelected(client_id)
    CM->>Chat: changeCurrentKey(MessageKey(peerId, id))
    alt unreadChatMessageCount > 0
        CM->>Chat: showChatPage(key)
        CM->>CM: unreadChatMessageCount = 0
    end
    CM->>WM: setTitle(getWindowNameWithId(peerId))
    CM->>File: updateCurrentClientId(id)
```

---

## 7. Timer loop ServerModel (500 ms)

```mermaid
flowchart TD
    Tick["Timer.periodic(500ms)"] --> T1["mainGetConnectStatus()\n→ connectStatus"]
    Tick --> T2{"desktopType == cm?"}

    T2 -->|нет| T5
    T2 -->|да| T3["cmCheckClientsLength(clients.length)"]

    T3 --> Drift{"списки совпадают?"}
    Drift -->|нет| Resync["updateClientState(res)"]
    Drift -->|да| T4{"clients.isEmpty?"}

    T4 -->|да| Hide["hideCmWindow()\ncounter++"]
    Hide --> AutoClose{"counter == 12\n(6 сек)?"}
    AutoClose -->|да| Close["windowManager.close()"]
    AutoClose -->|нет| T5

    T4 -->|нет| Show["showCmWindow()\ncounter = 0"]

    T5["updatePasswordModel()"]
    Resync --> T5
    Show --> T5
```

---

## 8. Интеграция чата и голосовых вызовов

```mermaid
flowchart TB
    subgraph ChatFlow["Chat в CM"]
        Key["MessageKey(peerId, connId)"]
        CMFlag["ChatModel.isConnManager = true"]
        Overlay["DraggableChatWindow\n(overlay.dart)"]
        Page["ChatPage"]
        Send["ChatModel.send()"]
        FFIChat["bind.cmSendChat(id, text)"]
    end

    CMFlag --> Key
    Key --> Overlay --> Page
    Page --> Send --> FFIChat

    subgraph Voice["Voice Call"]
        Status["ChatModel.voiceCallStatus\n(Rx variable)"]
    end

    ChatFlow --- Voice
```

---

## 9. Процессная архитектура (Rust ↔ Flutter)

```mermaid
flowchart TB
    subgraph MainProcess["Основной процесс rustdesk"]
        MainUI["Main Window\nDesktopTabPage"]
        Service["ServerModel.startService()\nслушает входящие"]
    end

    subgraph CMProcess["CM процесс (--cm)"]
        CMUI["DesktopServerPage"]
        CMSM["ServerModel (CM instance)"]
    end

    subgraph RustCore["Rust Core"]
        SCH["Server Connection Handler\nsrc/server/"]
        CMInterface["ui_cm_interface\nstart_ipc()"]
        CMHandler["ConnectionManager&lt;Handler&gt;"]
    end

    Service --> SCH
    SCH -->|"spawn / signal"| CMProcess
    CMInterface --> CMHandler
    CMHandler -->|"InvokeUiCM\naddConnection, update, remove"| CMSM
    CMSM --> CMUI
    CMUI -->|"authorize, close, permission"| CMHandler
    CMHandler --> SCH
```

---

## 10. Предлагаемая Clean Architecture для CM

> Целевой стек: **Riverpod 3** + **Freezed** + **desktop_multi_window** (опционально CM может остаться отдельным процессом, как в RustDesk).

```mermaid
flowchart TB
    subgraph Presentation["features/connection_manager/presentation"]
        Screen["ConnectionManagerScreen\n(= DesktopServerPage)"]
        Page["ConnectionManagerPage\n(= ConnectionManager)"]
        Widgets["ClientTabPanel\nPermissionPanel\nChatOverlay"]
        Ctrl["IncomingConnectionsController\n@riverpod"]
        ChatCtrl["CmChatController\n@riverpod"]
    end

    subgraph Application["features/connection_manager/application"]
        UC1["AuthorizeConnection"]
        UC2["RejectConnection"]
        UC3["TogglePermission"]
        UC4["SendChatMessage"]
        UC5["WatchIncomingClients"]
    end

    subgraph Domain["features/connection_manager/domain"]
        Entity["IncomingClient\n@freezed"]
        State["CmState\n@freezed"]
        Repo["IncomingConnectionRepository\nabstract"]
        VO["ClientId, PeerId, Permission"]
    end

    subgraph Infrastructure["features/connection_manager/infrastructure"]
        RepoImpl["IncomingConnectionRepositoryImpl"]
        Bridge["NativeBridge\n(cmAuthorize, cmClose, ...)"]
        IPCAdapter["CmIpcAdapter"]
    end

    Screen --> Page --> Widgets
    Widgets --> Ctrl & ChatCtrl
    Ctrl --> UC1 & UC2 & UC3 & UC5
    ChatCtrl --> UC4
    UC1 & UC2 & UC3 & UC4 & UC5 --> Repo
    RepoImpl -.-> Repo
    RepoImpl --> Bridge & IPCAdapter
```

### Маппинг RustDesk → Clean Architecture (CM)

| RustDesk | Clean Architecture |
|---|---|
| `DesktopServerPage` | `ConnectionManagerScreen` |
| `ConnectionManager` | `ConnectionManagerPage` |
| `ServerModel` | `IncomingConnectionsController` + `CmState` |
| `Client` | `IncomingClient` (@freezed) |
| `ChatModel` (CM mode) | `CmChatController` |
| `CmFileModel` | `CmFileTransferController` |
| `bind.cmAuthorize` etc. | `IncomingConnectionRepository` |
| `gFFI.serverModel` | `@Riverpod(keepAlive: true)` providers |
| Timer 500ms в ServerModel | `ref.listen` + `Stream` из repository |

### Bootstrap CM (Riverpod 3)

```mermaid
sequenceDiagram
    participant Main as main(List args)
    participant Boot as CmBootstrap
    participant Scope as ProviderScope
    participant App as ConnectionManagerApp
    participant Ctrl as IncomingConnectionsController

    Main->>Main: args.contains('--cm')
    Main->>Boot: runConnectionManager()
    Boot->>Boot: initEnv(appType: connectionManager)
    Boot->>Scope: ProviderScope(overrides: [cmModeProvider])
    Scope->>App: ConnectionManagerScreen()
    App->>Ctrl: build() → watch incomingClientsStream
    Ctrl->>Ctrl: ref.onDispose → closeAll()
```

---

## 11. Сводная таблица FFI-вызовов CM

| FFI (`bind.*`) | Назначение |
|---|---|
| `cmCheckClientsLength(length)` | Сверка списка клиентов Flutter ↔ Rust |
| `cmAuthorize(id)` | Разрешить подключение |
| `cmClose(id)` | Закрыть / отклонить |
| `cmSwitchPermission(id, name, enabled)` | Переключить разрешение |
| `cmSendChat(id, text)` | Отправить сообщение чата |
| `cmElevatePortable(id)` | Повысить привилегии (portable) |
| `mainGetConnectStatus()` | Статус rendezvous-сервера |
| `mainGetTemporaryPassword()` | Временный пароль хоста |
| `mainSetOption(key, value)` | Настройки approve/verification |
| `cmGetConfig(name: "hide_cm")` | Скрытый режим CM при старте |

---

## Связанные файлы RustDesk

| Файл | Назначение |
|---|---|
| `flutter/lib/main.dart` | `runConnectionManagerScreen()`, `showCmWindow()`, `hideCmWindow()` |
| `flutter/lib/desktop/pages/server_page.dart` | `DesktopServerPage`, `ConnectionManager`, UI панели |
| `flutter/lib/models/server_model.dart` | `ServerModel`, `Client`, timer loop |
| `flutter/lib/models/chat_model.dart` | Чат в режиме CM |
| `flutter/lib/models/cm_file_model.dart` | Файловые операции в CM |
| `src/ui/cm.rs` | Legacy Sciter CM (Rust) |
| `src/ui_cm_interface.rs` | IPC между server и CM UI |
