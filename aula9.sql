-- Questões Exercício

-- 1. 
-- R: Cliente(ClienteID, Cidade, Nome), Pedido(ClienteID, PedidoID, ValorTotal). 
-- São apenas 2 relações, Cliente e Pedido

-- 2. 
-- R: 
--  π Nome, PedidoID, ValorTotal
--			   |
--	  σ Cidade = 'São Paulo'
--			   |
--	   |------ ⨝ ------|
--	Cliente			 Pedido

-- 3.
-- R: π Nome, PedidoID, ValorTotal(σ Cidade = 'São Paulo'(Cliente ⨝ Pedido))

-- 4.
-- R: A otimização que poderia ser feita é, antes de fazer o JOIN entre Cliente e Pedido, já filtrar
-- apenas as linhas da tabela Cliente que com cidade = 'São Paulo'. Então, com o resultado dessa lista,
-- selecionar as colunas Nome e Cliente_ID, e da tabela Pedido selecionar apenas ClienteID, PedidoID e 
-- ValorTotal (apenas a coluna DataPedido ficaria de fora). Então, fazer o JOIN entre Pedido e Cliente,
-- e por fim retirar a coluna ClienteID. Assim, os JOINS usariam apenas o número absolutamente necessário
-- de colunas para a operação de junção e para a posterior seleção.

-- Uma transação em um banco de dados é um conjunto de operações que seguem o princípio ACID:
-- Atomicidade, Consistência, Isolamento, Durabilidade
-- Ou seja, após a transação começar ou a transação será concluída e todas as operações serão executadas, 
-- ou a transação falhará e nenhuma das operações serão executadas. Além disso, essas operações não interferirão
-- em outras transações que estão em andamento.
-- As 3 operações básicas que permitem utilizar das transações são: BEGIN, que indica o início de uma nova transação;
-- COMMIT, que indica o sucesso e fim de uma transação (se existir uma aberta), concretizando todas as operações após o BEGIN; 
-- e ROLLBACK, que indica a falha e fim de uma transação (se existir uma aberta), desfazendo/invalidando todas as operações após o BEGIN.

-- heurística = otimizações
-- um exemplo é fazer as seleções e projeções o mais cedo possível para os dados unidos ficarem menores
