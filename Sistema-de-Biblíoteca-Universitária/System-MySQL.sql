CREATE DATABASE BibliotecaUniversitária;
USE BibliotecaUniversitária;

CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(50) NOT NULL
);

CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    ano_publicacao INT,
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE emprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_livro INT NOT NULL,
    data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_devolucao DATETIME NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id),
    FOREIGN KEY (id_livro) REFERENCES livros(id)
);

INSERT INTO alunos (nome, curso) VALUES
('João Silva', 'Ciência da Computação'),
('Maria Oliveira', 'Engenharia Civil'),
('Carlos Souza', 'Administração');

INSERT INTO livros (titulo, autor, ano_publicacao, disponivel) VALUES
('Introdução ao SQL', 'Ana Santos', 2020, TRUE),
('Algoritmos Avançados', 'Pedro Rocha', 2018, FALSE),
('História da Arte', 'Clara Mendes', 2015, TRUE),
('Física Quântica', 'Roberto Alves', 2021, FALSE),
('Gestão de Projetos', 'Fernanda Lima', 2019, TRUE);

INSERT INTO emprestimos (id_aluno, id_livro, data_emprestimo, data_devolucao) VALUES
(1, 2, '2023-10-01 09:00:00', NULL),
(2, 4, '2023-10-05 14:30:00', NULL);

DELIMITER //
CREATE PROCEDURE RealizarEmprestimo(
    IN p_id_aluno INT,
    IN p_id_livro INT
)
BEGIN
    DECLARE qtd_emprestimos INT;
    DECLARE livro_disponivel BOOLEAN;
    DECLARE aluno_existe INT;
    DECLARE livro_existe INT;
    
    SELECT COUNT(*) INTO aluno_existe FROM alunos WHERE id = p_id_aluno;
    IF aluno_existe = 0 THEN
        SELECT 'Erro: Aluno não encontrado.' AS Mensagem;
        LEAVE proc;
    END IF;
    
    SELECT COUNT(*) INTO livro_existe FROM livros WHERE id = p_id_livro;
    IF livro_existe = 0 THEN
        SELECT 'Erro: Livro não encontrado.' AS Mensagem;
        LEAVE proc;
    END IF;
    
    SELECT COUNT(*) INTO qtd_emprestimos 
    FROM emprestimos 
    WHERE id_aluno = p_id_aluno AND data_devolucao IS NULL;

    SELECT disponivel INTO livro_disponivel FROM livros WHERE id = p_id_livro;
    
    IF qtd_emprestimos >= 3 THEN
        SELECT 'Erro: Aluno já possui 3 livros emprestados. Devolva algum livro antes de pegar outro.' AS Mensagem;
    ELSEIF NOT livro_disponivel THEN
        SELECT 'Erro: Livro não está disponível para empréstimo.' AS Mensagem;
    ELSE

        INSERT INTO emprestimos (id_aluno, id_livro) VALUES (p_id_aluno, p_id_livro);
        
    
               UPDATE livros SET disponivel = FALSE WHERE id = p_id_livro;
        
        SELECT 'Empréstimo realizado com sucesso!' AS Mensagem;
    END IF;
END //
DELIMITER ;

CALL RealizarEmprestimo(3, 1);

INSERT INTO emprestimos (id_aluno, id_livro, data_emprestimo, data_devolucao) VALUES
(1, 3, '2023-10-10 10:00:00', NULL),
(1, 5, '2023-10-10 10:05:00', NULL);

CALL RealizarEmprestimo(1, 1);

CALL RealizarEmprestimo(2, 2);

SELECT 
    e.id AS emprestimo_id,
    a.nome AS aluno,
    a.curso,
    l.titulo AS livro,
    l.autor,
    e.data_emprestimo
FROM 
    emprestimos e
    JOIN alunos a ON e.id_aluno = a.id
    JOIN livros l ON e.id_livro = l.id
WHERE e.data_devolucao IS NULL
ORDER BY e.data_emprestimo;