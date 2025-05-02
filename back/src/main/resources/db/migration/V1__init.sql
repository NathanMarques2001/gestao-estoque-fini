CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('super_admin', 'admin', 'operador') NOT NULL,
    status TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE estoques (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo ENUM('principal', 'secundário') NOT NULL,
    localizacao VARCHAR(255),
    estoque_minimo INT NOT NULL,
    estoque_maximo INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
	  nome_fornecedor VARCHAR(255) NOT NULL,
    fornecedor_id INT NOT NULL,
    preco_compra DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    unidade_medida VARCHAR(50) NOT NULL,
    validade DATE,
    estoque_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id) ON DELETE CASCADE,
    FOREIGN KEY (estoque_id) REFERENCES Estoques(id) ON DELETE CASCADE
);

CREATE TABLE notas_fiscais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fornecedor_id INT NOT NULL,
    xml_arquivo TEXT NOT NULL,
    data_emissao DATE NOT NULL,
    data_importacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id) ON DELETE CASCADE
);

CREATE TABLE itens_nota_fiscal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (nota_id) REFERENCES Notas_Fiscais(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id) ON DELETE CASCADE
);

CREATE TABLE transferencias_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estoque_origem_id INT NOT NULL,
    estoque_destino_id INT NOT NULL,
    status ENUM('pendente', 'aprovado', 'cancelado') NOT NULL,
    aprovador_id INT,
    solicitante_id INT,
    data_solicitacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_aprovacao TIMESTAMP,
    FOREIGN KEY (estoque_origem_id) REFERENCES estoques(id) ON DELETE CASCADE,
    FOREIGN KEY (estoque_destino_id) REFERENCES estoques(id) ON DELETE CASCADE,
    FOREIGN KEY (aprovador_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (solicitante_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE itens_transferencia_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transferencia_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (transferencia_id) REFERENCES transferencias_estoque(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE solicitacoes_reposicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    solicitante_id INT,
    aprovador_id INT,
    status ENUM('pendente', 'aprovado', 'rejeitado') NOT NULL,
    data_solicitacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_aprovacao TIMESTAMP,
    FOREIGN KEY (solicitante_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (aprovador_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE itens_solicitacao_reposicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (solicitacao_id) REFERENCES solicitacoes_reposicao(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE inventarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    data_inventario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE itens_inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inventario_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade_registrada INT NOT NULL,
    quantidade_real INT NOT NULL,
    justificativa TEXT,
    FOREIGN KEY (inventario_id) REFERENCES inventarios(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE logs_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    acao TEXT NOT NULL,
    descricao TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);
