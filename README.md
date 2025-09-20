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
Seguem algumas orientações sobre como utilizar esta aplicação da melhor maneira.
### 1. Conexão com a API Phish.in
A conexão já é realizada automaticamente na classe [APIConsume.rb](https://github.com/klesleybr/consuming-phish-api/blob/main/APIConsume.rb), bastando apenas que passar o *link* base da API para o construtor no momento da instância do objeto.

`consume = APIConsume.new("https://phish.in/api/v2/")`


### 2. Conexão com o banco de dados
`db = Database.new("localhost", "user", "pwd", "db_name")`
> **Atenção:** o `db_name` do referido construtor é o nome *default* do seu banco de dados PostgreSQL (geralmente, é *postgresql*).