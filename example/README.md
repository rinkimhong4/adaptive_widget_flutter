# Reusable Flutter CRUD with Provider

A generic, drop-in CRUD layer built on `http` + `provider`. Add a new resource
in **3 small files** — no boilerplate per endpoint, no duplicated state code.

```
UI ─► Provider<T> ─► Repository<T> ─► ApiService ─► HTTP
```

The top three layers are **generic**. The only thing you write per resource is
a model + a 5-line provider.

---

## 📁 Folder Structure

```
lib/
├── api/config/
│   ├── api_service.dart           # Generic HTTP client (callApi + callApiList)
│   └── function/function.dart     # Snackbar / alert helpers
│
├── repositories/
│   └── base_repository.dart       # Generic CRUD<T> — getAll/getById/create/update/delete
│
├── providers/
│   ├── base_crud_provider.dart    # Generic ChangeNotifier<T> — items, loading, errors
│   └── <resource>_provider.dart   # One per resource (5 lines)
│
├── models/
│   └── <resource>.dart            # One per resource
│
├── widgets/                       # Reusable form dialogs, etc.
└── screens/                       # Per-screen UI
```

---

## 🚀 Setup

```yaml
# pubspec.yaml
dependencies:
  http: ^1.2.0
  provider: ^6.1.2
  get: ^4.6.6   # only used by notificationAlert / processAlert
```

In `main.dart`, build one `ApiService` and inject providers:

```dart
void main() {
  final api = ApiService(
    baseUrl: 'https://your-api.com/api/v1',
    accessToken: 'your_token_here', // optional
  );

  runApp(MultiProvider(
    providers: [
      Provider<ApiService>.value(value: api),
      ChangeNotifierProvider(create: (_) => ProductProvider(api)),
      ChangeNotifierProvider(create: (_) => CategoryProvider(api)),
      // Add more here as you grow
    ],
    child: const MyApp(),
  ));
}
```

---

## ➕ Add a new resource in 3 steps

### Step 1 — Model (`lib/models/order.dart`)

```dart
class Order {
  final int? id;
  final double total;

  Order({this.id, required this.total});

  factory Order.fromJson(Map<String, dynamic> j) =>
      Order(id: j['id'], total: (j['total'] as num).toDouble());

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'total': total,
      };
}
```

### Step 2 — Provider (`lib/providers/order_provider.dart`)

```dart
class OrderRepository extends BaseRepository<Order> {
  OrderRepository(ApiService api)
      : super(
          api: api,
          endpoint: '/orders',
          fromJson: Order.fromJson,
          toJson: (o) => o.toJson(),
          listDataKey: 'data', // change/remove based on your API
        );
}

class OrderProvider extends BaseCrudProvider<Order> {
  OrderProvider(ApiService api)
      : super(repository: OrderRepository(api), idSelector: (o) => o.id);
}
```

### Step 3 — Register in `main.dart`

```dart
ChangeNotifierProvider(create: (_) => OrderProvider(api)),
```

Done. You now have `fetchAll`, `fetchById`, `create`, `update`, `delete`,
loading/error state, and automatic list updates for `Order`.

---

## 🛠 Using the provider in any screen

```dart
// Trigger
context.read<ProductProvider>().fetchAll();
context.read<ProductProvider>().create(product);
context.read<ProductProvider>().update(id, product);
context.read<ProductProvider>().delete(id);

// Listen
Consumer<ProductProvider>(
  builder: (_, p, __) {
    if (p.isLoading && p.isEmpty) return const CircularProgressIndicator();
    if (p.hasError && p.isEmpty)  return Text(p.errorMessage!);
    return ListView(children: p.items.map(...).toList());
  },
)
```

### Provider state available

| Property | Type | Description |
|---|---|---|
| `items` | `List<T>` | Current cached list |
| `selected` | `T?` | Last item loaded by `fetchById` |
| `status` | `CrudStatus` | `idle`, `loading`, `success`, `error` |
| `isLoading` | `bool` | Shortcut for `status == loading` |
| `hasError` | `bool` | Shortcut for `status == error` |
| `isEmpty` | `bool` | `items.isEmpty` |
| `errorMessage` | `String?` | Last error message |

---

## 🔧 Configuring for your API shape

The repository takes two knobs that cover most real-world APIs:

### `listDataKey` — where the array lives in list responses

| Your API returns | Set `listDataKey` to |
|---|---|
| `[ {...}, {...} ]` (raw array) | `null` (default) |
| `{ "data": [...] }` | `'data'` |
| `{ "products": [...] }` (DummyJSON) | `'products'` |
| `{ "results": [...] }` (Django) | `'results'` |
| `{ "data": { "items": [...] } }` | `'data'` (auto-dives into `items`) |

If the key doesn't match, the `_extractList` helper falls back to common keys
(`data`, `items`, `results`, `list`, `records`, `products`) before throwing a
clear error.

### `createSuffix` — for non-standard create endpoints

| Your API uses | Set `createSuffix` to |
|---|---|
| `POST /products` (standard REST) | `''` (default) |
| `POST /products/add` (DummyJSON) | `'/add'` |
| `POST /products/create` | `'/create'` |

---

## 🧱 What's reusable vs what you write

| Layer | Reusable? | Write per resource? |
|---|---|---|
| `ApiService` | ✅ Once | ❌ |
| `BaseRepository<T>` | ✅ Once | ❌ |
| `BaseCrudProvider<T>` | ✅ Once | ❌ |
| Concrete `Repository` | — | ✅ ~10 lines |
| Concrete `Provider` | — | ✅ ~5 lines |
| Model | — | ✅ Required |
| Screen / form widgets | — | ✅ Required |

---

## 🧯 Common errors

### `Null is not a subtype of List<dynamic>`

Your `listDataKey` doesn't match the API shape. Add this in `callApiList` to
debug:

```dart
debugPrint('API RESPONSE: $decoded');
```

Then update `listDataKey` (or remove it for raw arrays).

### `Expected a list but could not find one`

The defensive extractor checked all common keys and found nothing. Either:

- The endpoint isn't returning a list (maybe an error object?)
- The list is nested deeper than one level — extract it manually in the
  repository's `getAll` override

### CORS errors on web

DummyJSON and most public APIs allow CORS. Your own API likely doesn't.
Either configure CORS on the backend or run the Flutter app on mobile/desktop
during development.

---

## 📦 What you don't get (yet)

These are not in the base provider — add them when needed:

- **Pagination** — override `fetchAll` in your provider to track `skip`/`page`
- **Search/filter** — pass `queryParams` to `fetchAll`
- **Optimistic updates** — modify `items` before the API call returns
- **Offline cache** — wrap repository calls with shared_preferences/hive
- **Cancellation** — replace `http.Client` with a `CancelToken`-aware client

The base classes are small on purpose. Extend them per resource when you need
something specific instead of bloating the generic layer.