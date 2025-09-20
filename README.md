# Consumindo a API Phish.in (v.2)
Este é um pequeno projeto que consiste no consumo da API [Phish.in (v.2)](https://petstore.swagger.io/?url=https%3A%2F%2Fphish.in/api/v2/swagger_doc#/) e no armazenamento dos dados retornados no banco de dados PostgreSQL. A aplicação também dispõe de métodos que facilitam a consulta de dados, sendo possível utilizar diferentes parâmetros para busca.

## O que é *Phish.in*?
Conforme a documentação, a Phish.in é um *website* destinado à descoberta e compartilhamento de gravações da **banda Phish**. O *site* foi criado em 2013 e segue como um projeto *open source*, em que admiradores ao redor do mundo podem compartilhar suas faixas. <br>
A **banda Phish** é uma banda de rock estadunidense caracterizada pelas longas seções de improvisação (*jams*), pela realização de shows em turnê, pela fusão entre diversos gêneros musicais e por relizar *covers* de diversos artistas dos mais diferentes ritmos ([mais informações aqui](https://en.wikipedia.org/wiki/Phish)).

## Tecnologias Utilizadas
Para construção desta aplicação, foram utilizadas as seguintes ferramentas:
* Ruby
* PostgreSQL
* [PG](https://rubygems.org/gems/pg/versions/1.5.6?locale=pt-BR) 
* [HTTParty](https://github.com/jnunemaker/httparty)

O Ruby foi utilizado como linguagem de programação principal, o PG como interface para transações com o SGBD PostgreSQL e o HTTParty para gerenciar as requisições HTTP.

## Como utilizar?
Seguem algumas orientações sobre como utilizar esta aplicação da melhor maneira (você pode acompanhar este processo no arquivo [Main.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/Main.rb)).

### 1. Conexão com a API Phish.in
A conexão já é realizada automaticamente na classe [APIConsume.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/APIConsume.rb), bastando apenas que passar o *link* base da API para o construtor no momento da instância do objeto.

`consume = APIConsume.new("https://phish.in/api/v2/")`

### 2. Conexão com o banco de dados
A classe [Database.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/Database.rb) está encarregada, entre outras coisas, de simplificar a conexão com o banco de dados no PostgreSQL. Basta simplesmente passar os dados do SGBD para o construtor no momento de instanciar a classe.

`db = Database.new("localhost", "user", "pwd", "db_name")`
> **Atenção:** o `db_name` do referido construtor é o nome *default* do seu banco de dados PostgreSQL (geralmente, é *postgresql*).

Na inicialização do objeto, é criado o banco de dados `tracks`, com as tabelas `info` e `artists`, em que a primeira armazena informações das gravações e a segunda armazena os artistas já "imitados" pela banda Phish.

| artists             | info                                     |
|---------------------|------------------------------------------|
| id INTEGER NOT NULL | id (INTEGER) NOT NULL                    |
| name VARCHAR(150)   | title VARCHAR(200) NOT NULL              | 
|                     | artist_id INTEGER REFERENCES artists(id) |
|                     | mp3_url TEXT NOT NULL                    |
|                     | date_track DATE DEFAULT NULL             |
> Estruturas das tabelas `artists` e `info`.

Após a conexão, também é possível utilizar os recursos restantes oferecidos pela classe, tais como a **inserção e a consulta de dados**.

### 3. Coletar os dados da API e armazenar no banco de dados

Para a presente aplicação, os únicos dados que interessam dizem respeito às faixas (*tracks*) de música (título, url do arquivo .mp3, data de gravação) e os artistas dos *covers* realizados pela banda Phish.

> Isso não impede o usuário de ir além, buscando dados conforme os parâmetros *shows*, *year*, *playlists*, entre outros.

A busca dos dados mencionados é feita pela função `tracks(limit)`, da classe [APIConsume.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/APIConsume.rb), em que o parâmetro  `limit` india o limite de faixas que serão retornadas.

`api_data = consume.tracks(1500)`

Os dados são retornados na forma de uma lista de registros JSON. Usando uma estrutura de repetição, é possível ir alocando os dados no PostgreSQL a partir das funções `insert_artists()` e `insert_info()` da classe [Database](https://github.com/klesleybr/consuming-phish-api/blob/main/Database.rb).<br>
O arquivo [Main.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/Main.rb) já realiza essas operações e, ao final, ainda faz uma junção de todos os dados de ambas as tabelas, listando-os com a formatação apropriada.


### 4. Funcionalidades

A classe [Database](https://github.com/klesleybr/consuming-phish-api/blob/main/Database.rb) oferece alguns recursos para inserção e consulta de dados de forma simplificada, a saber:

* `insert_artists(name)` <br>
A função recebe um parâmetro `name`, armazena o artista na tabela `artists` e retorna o ID da linha correspondente ao último registro.

* 