[![Build Status](https://travis-ci.org/osamuca/api-starter.svg?branch=develop)](https://travis-ci.org/osamuca/api-starter)

# api-starter
Clonando o repo você terá uma api básica, preparada para autenticação e CRUD, os códigos estão modularizados para que você possa escolher outras ferramentas se assim preferir.

### Ferramentas

+ #### [NodeJS](https://nodejs.org/en/)
  Para desenvolver esse starter foi utilizada a a versão LTS do nodejs, que era a: `8.9.3`.

+ #### [MongoDB](https://www.mongodb.com)
  Banco de dados não relacional, o MongoDB foi escolhido como banco desse starter devido à sua alta popularidade.

+ #### [Restify](http://restify.com)
  Framework para controlar as rotas. Escolhido por ser middleware-based, permitindo alta gestão sobre tudo o que acontece na aplicação.

+ #### [JWT authentication](https://jwt.io/)
  JWT é apenas o protocolo de transporte de informações seguras.

+ #### [dotEnv](https://www.npmjs.com/package/dotenv)
  Módulo para carregar configurações via arquivo `.env` serve para colocarmos informações de configuração que não devem ficar visíveis quando o code subir para o gerenciador de versão, como por exemplo senhas de acesso à APIs externas.


### Utilização
+ #### Certifique-se de ter instalado em seu computador:
  - **[NodeJS](https://nodejs.org/en/)**, para conferir, abra um terminal e digite `node --version`
  - **[MongoDB](https://www.mongodb.com)**, para conferir, abra um terminal e digite `mongo --version`
+ ##### Clone o repositório
+ ##### Instale as dependências com `npm install`
+ ##### Certifique-se de executar o MongoDB como o comando `mongod` ou de colocá-lo em execução automática, para que a API funcione, é essencial que o mongo esteja sendo executado.
+ ##### Execute e você terá uma api escutando em `localhost:5520`
  - **Você irá precisar de uma ferramenta para fazer requisições HTTP**   
  Para isso você pode instalar o [POSTMAN](https://www.getpostman.com/)
  que é uma ótima ferramenta, antes um app do chrome, hoje um software standalone que você pode baixar e instalar sem dificuldade.  
  Se tiver no linux (Que eu aconselho fortemente), pode utilizar o [curl](https://curl.haxx.se/docs/manpage.html), que é utilizado nos exemplos abaixo

  - **Cadastre um user novo**
  Para cadastrar um novo usuário você precisa consumir a rota **http://localhost:5520/api/v1/users** utilizando o método POST, passando o seguinte objeto como data:  

  ```json
    {
        "name": "seu nome"
      , "email": "seu@email.com"
      , "senha": "senha para o seu usuario"
    }

  //Exemplo com CURL:

    curl -H "Content-Type: application/json" -X POST -d '{  "username": "seu nome", "email": "seu@email.com", "senha": "senha para o seu usuario"}' http://localhost:5520/api/v1/users

  ```

  - **Faça LOGIN** Agora você já pode efetuar login, com o usuário criado acima, para isso, consuma rota **http://localhost:5520/api/v1/auth** utilizando o método POST, passando o seguinte objeto como data:  

  ```json
    {
        "email": "seu@email.com"
      , "senha": "senha para o seu usuario"
    }

  Exemplo com CURL:

  curl -H "Content-Type: application/json" -X POST -d '{  "email": "seu@email.com", "senha": "senha para o seu usuario"}' http://localhost:5520/api/v1/auth

  Isso retornará seu token.

  ```
  - **CRUD** para usuários todas as funções de CRUD estão prontas, siga o
  modelo:  
  URL: http://localhost:5520/api/v1
    - GET em /users retorna todos os usuários cadastrados
    - GET em /users/{_idDoUsuário} retorna os dados desse usuário, substitua `{_idDoUsuário}` pelo campo `_id`, a rota ficará mais ou menos assim:
      /users/59c2a1833cd2d204529667dc
    - POST em /users com o objeto `{name, email, senha}` cria um novo usuário
    - PUT em /users/{_idDoUsuário} com o objeto `{ senha }` altera a senha do usuário, não é permitido alterar nem o nome nem o email de um usuário.
    - DELETE em /users/{_idDoUsuário} remove o usuário.
