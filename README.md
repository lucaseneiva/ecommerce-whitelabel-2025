# Ecommerce Whitelabel 2025

Projeto desenvolvido para o processo seletivo, consistindo em uma solução Fullstack (NestJS + Flutter) com arquitetura Whitelabel (Multi-tenant).

## 🚀 Tecnologias Utilizadas

### Backend (API)
- **NestJS**: Framework principal.
- **TypeORM + SQLite**: Persistência de dados.
- **Passport + JWT**: Autenticação segura.
- **Swagger**: Documentação automática da API.
- **Axios**: Consumo das APIs externas (Fornecedores).

### Frontend (App)
- **Flutter**: Framework UI.
- **Riverpod**: Gerenciamento de estado e Injeção de Dependência.
- **Dio**: Cliente HTTP.
- **GoRouter**: Gerenciamento de rotas e redirecionamentos.

---

## 🎨 Arquitetura Whitelabel

A aplicação identifica o cliente baseada na **URL de acesso** (Host Header).
1. O App Flutter consulta a API (`/config`) enviando o host.
2. A API verifica no banco de dados qual `Client` possui aquela URL.
3. A API retorna as configurações visuais (Nome da Loja, Cor Primária).
4. O Flutter reconstrói o `ThemeData` dinamicamente antes de montar a árvore de widgets.

---

## 🗂 Diagrama Entidade Relacionamento (DER)

O banco de dados gerencia a relação entre as Lojas (Clients) e seus Usuários autorizados. Os produtos não são persistidos localmente, sendo consumidos em tempo real dos fornecedores externos.

```mermaid
erDiagram
    CLIENT ||--|{ USER : "possui"
    
    CLIENT {
        int id PK
        string name "Nome da Loja"
        string url "URL identificadora (ex: loja-joao.com)"
        string primaryColor "Cor Hexadecimal"
    }

    USER {
        int id PK
        string email UK
        string password_hash
        int clientId FK
    }
