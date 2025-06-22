
## Visão Geral
Sistema de gerenciamento de biblioteca universitária com controle de empréstimos, alunos e acervo de livros, implementado em MySQL com stored procedures para validação de regras de negócio.

## 📦 Estrutura do Banco de Dados

### Tabela `alunos`
| Coluna        | Tipo         | Descrição                |
|---------------|--------------|--------------------------|
| id            | INT          | Chave primária           |
| nome          | VARCHAR(100) | Nome completo do aluno   |
| curso         | VARCHAR(50)  | Curso matriculado        |

### Tabela `livros`
| Coluna           | Tipo         | Descrição                     |
|------------------|--------------|-------------------------------|
| id               | INT          | Chave primária                |
| titulo           | VARCHAR(200) | Título da obra                |
| autor            | VARCHAR(100) | Autor do livro                |
| ano_publicacao   | INT          | Ano de publicação             |
| disponivel       | BOOLEAN      | Status de disponibilidade (1-disponível, 0-indisponível) |

### Tabela `emprestimos`
| Coluna           | Tipo         | Descrição                     |
|------------------|--------------|-------------------------------|
| id               | INT          | Chave primária                |
| id_aluno         | INT          | FK para tabela alunos         |
| id_livro         | INT          | FK para tabela livros         |
| data_emprestimo  | DATETIME     | Data/hora do empréstimo       |
| data_devolucao   | DATETIME     | Data/hora da devolução (NULL quando ativo) |

## ⚙️ Funcionalidades Principais

### 📖 Stored Procedure: `RealizarEmprestimo`
``sql
CALL RealizarEmprestimo(id_aluno, id_livro);
Fluxo de Operação:

Valida existência do aluno e livro

Verifica se aluno possui menos de 3 empréstimos ativos

Confirma disponibilidade do livro

Registra empréstimo e atualiza status do livro

Mensagens de Retorno:

✅ Sucesso: "Empréstimo realizado com sucesso!"

❌ Erros: Mensagens específicas para cada cenário de falha

🧪 Testes Implementados
Caso 1: Empréstimo válido
sql
CALL RealizarEmprestimo(3, 1); -- Aluno dentro do limite, livro disponível
Caso 2: Limite excedido
sql
CALL RealizarEmprestimo(1, 3); -- Aluno com 3 empréstimos ativos
Caso 3: Livro indisponível
sql
CALL RealizarEmprestimo(2, 2); -- Livro marcado como indisponível
🔍 Consultas Úteis
Listar empréstimos ativos
sql
SELECT 
    a.nome AS aluno,
    a.curso,
    l.titulo AS livro,
    l.autor,
    e.data_emprestimo AS "data do empréstimo"
FROM emprestimos e
JOIN alunos a ON e.id_aluno = a.id
JOIN livros l ON e.id_livro = l.id
WHERE e.data_devolucao IS NULL;
Livros disponíveis
sql
SELECT titulo, autor FROM livros WHERE disponivel = 1;
🛠️ Implementação
Executar script SQL completo para criação do banco

Popular tabelas com dados iniciais

Criar stored procedures

Executar testes de validação

bash
mysql -u usuario -p < script_biblioteca.sql
📌 Requisitos
MySQL 5.7 ou superior

Privilégios para criação de bancos de dados

📄 Licença
MIT License - Disponível para uso acadêmico e comercial
