# Service API avec Axios et Mocks

Ce dossier contient les services API utilisant Axios et les mocks pour les tests.

## Structure

```
services/
├── api.js                    # Service API principal avec Axios
├── api.test.js              # Tests unitaires pour le service API
├── __mocks__/
│   └── axiosMock.js         # Utilitaires pour les mocks Axios
└── README.md                # Ce fichier
```

## Utilisation d'Axios

### Configuration

Le service API utilise une instance Axios configurée avec :

```javascript
const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});
```

### Méthodes disponibles

- `getUsers()` - Récupère tous les utilisateurs
- `createUser(userData)` - Crée un nouvel utilisateur
- `countUsers()` - Compte le nombre d'utilisateurs

## Tests avec Mocks Axios

### Configuration des mocks

```javascript
import { mockAxiosInstance, mockAxiosResponse, mockAxiosError, clearAxiosMocks } from './__mocks__/axiosMock';

// Mock axios
jest.mock('axios');

describe('API Tests', () => {
  beforeEach(() => {
    clearAxiosMocks();
  });
});
```

### Exemples d'utilisation

#### Mock d'une réponse réussie

```javascript
const mockUsers = [
  { id: 1, firstName: "John", lastName: "Doe" },
  { id: 2, firstName: "Jane", lastName: "Smith" },
];

mockAxiosInstance.get.mockResolvedValueOnce(mockAxiosResponse(mockUsers));

const result = await userService.getUsers();
expect(result).toEqual(mockUsers);
```

#### Mock d'une erreur

```javascript
const axiosError = mockAxiosError("Request failed", 400, { detail: "Erreur API" });
mockAxiosInstance.post.mockRejectedValueOnce(axiosError);

await expect(userService.createUser(userData)).rejects.toThrow("Erreur API");
```

#### Mock d'une réponse avec statut personnalisé

```javascript
const mockResponse = { message: "User created successfully" };
mockAxiosInstance.post.mockResolvedValueOnce(mockAxiosResponse(mockResponse, 201, "Created"));
```

### Utilitaires disponibles

#### `mockAxiosResponse(data, status, statusText)`
Crée une réponse Axios mockée.

```javascript
mockAxiosResponse({ users: [] }, 200, "OK")
```

#### `mockAxiosError(message, status, data)`
Crée une erreur Axios mockée.

```javascript
mockAxiosError("Request failed", 400, { detail: "Bad request" })
```

#### `clearAxiosMocks()`
Nettoie tous les mocks Axios.

```javascript
beforeEach(() => {
  clearAxiosMocks();
});
```

## Tests d'intégration

Pour les tests d'intégration avec des composants React, voir `Form.integration.test.js` pour des exemples complets.

### Exemple de test d'intégration

```javascript
test('successfully submits form with valid data', async () => {
  const mockUserData = {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    dob: '1990-01-01',
    city: 'Paris',
    postalCode: '75001',
  };

  mockAxiosInstance.post.mockResolvedValueOnce(mockAxiosResponse({
    message: 'User created successfully',
    user: mockUserData,
  }, 201));

  render(<Form />);

  // Remplir le formulaire
  await userEvent.type(screen.getByLabelText(/prénom/i), mockUserData.firstName);
  // ... autres champs

  // Soumettre
  fireEvent.click(screen.getByRole('button', { name: /soumettre/i }));

  // Vérifier le résultat
  await waitFor(() => {
    expect(screen.getByText(/utilisateur créé avec succès/i)).toBeInTheDocument();
  });
});
```

## Avantages des mocks Axios

1. **Contrôle total** : Vous contrôlez exactement ce que l'API retourne
2. **Tests rapides** : Pas d'appels réseau réels
3. **Tests isolés** : Les tests ne dépendent pas de l'état du serveur
4. **Scénarios d'erreur** : Facile de tester les cas d'erreur
5. **Cohérence** : Même structure de réponse que l'API réelle

## Bonnes pratiques

1. **Toujours nettoyer les mocks** dans `beforeEach`
2. **Tester les cas d'erreur** en plus des cas de succès
3. **Vérifier les appels** avec `toHaveBeenCalledWith`
4. **Utiliser des données réalistes** dans les mocks
5. **Documenter les mocks complexes** avec des commentaires 