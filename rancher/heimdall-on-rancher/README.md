<div align="center">
  <a href="https://github.com/getheimdall/heimdall"><img src="../../tsuru/heimdall-on-tsuru/images/logo-heimdall.png" width="80" title="Heimdall" /></a>
  <a href="http://www.conductor.com.br/"><img src="../../tsuru/heimdall-on-tsuru/images/logo-conductor.png" width="300" title="Conductor Tecnologia" /></a>
</div>
<br />

# Subindo o <a href="https://getheimdall.io">getheimdall.io</a> no <a href="https://rancher.com">Rancher 2.0</a>
O <a href="https://getheimdall.io">getheimdall.io</a> é um orquestrador de API's que tem como objetivo trazer um caminho mais simples de manipular as requisições e respostas de sistemas empresariais

# Como funciona o Heimdall?
O Heimdall se divide em 4 partes que são essenciais para o funcionamento do orquestrador, são elas:
* Config  
O módulo de configurações do Heimdall é onde são centralizadas todas as configurações sejam ela de banco de dados, redis, rabbitmq e outros
* Gateway  
O Gateway é responsável por parte do mapeamento de rotas do sistema
* API  
A API é o módulo onde são recebidos, tratados e enviados os dados tanto para o front-end, quando para o banco de dados
* Front-end  
O Front-end é o módulo que o usuário terá acesso após tudo ser instalado corretamente

De acordo com a ordem, todos os módulos devem ser iniciados para que tenhamos o orquestrador em si, e é isso que faremos para inseri-lo no Rancher 2.0

# Pré-configurações
Primeiramente, certifique-se que já se encontra com o Rancher rodando no seu servidor, já com um Cluster + Node cadastrados e com um Project registrado 
para podermos cadastrar nossas Namespace's no mesmo. Caso não esteja, clique <a href="https://github.com/conductorlabs/wrapper/tree/master/rancher">aqui</a> para 
seguir nosso tutorial de como subir e configurar o Rancher para subirmos aplicações nele.

# Subindo os serviços (PostgreSQL, RabbitMQ, Redis)
Antes de subirmos os módulos do Heimdall, vamos subir antes os serviços nos quais os módulos funcionam por cima, buscando dados e gerenciando rotas<br />
Primeiro vamos subir o PostgreSQL, para fazermos isso, vamos nos nossos Workloads do projeto e clicar em Deploy. O nome da nossa aplicação será <code>postgres-heimdall</code> 
a imagem dele será <code>postgres:alpine</code>, e caso não exista, vamos criar uma Namespace chamada <code>services</code> para deixá-lo dentro dela. Após isso, externalize 
a porta <code>5432</code> do nosso serviço e vamos adicionar as seguintes environments (você pode alterá-las, mas terá de se lembrar de alterar quando for alterar o arquivo do heimdall-config): 
```console
POSTGRES_DB = heimdall
POSTGRES_PASSWORD = 123456
POSTGRES_USER = postgres
```
A página ficará algo parecido com isso: 
<div align="center">
  <img src="./images/deploy-postgres.PNG" title="Fazendo deploy do PostgreSQL" />
</div>
<br />
Após isso, basta clicar em Launch e aguardar subir nosso PostgreSQL.
<br /><br />
Com o PostgreSQL ativo, vamos agora subir o redis. Para subir o redis começaremos da mesma forma do PostgreSQL, clicando em Deploy para adicionarmos um 
novo deploy, desta vez, o nome da aplicação será <code>redis-heimdall</code> e nossa imagem será <code>redis:alpine</code>, com isso configurado, basta clicarmos em Launch, 
não precisaremos definir nenhuma porta para externalizar nem nenhum environment para o redis.
<br /><br />
Após subir o redis, por fim, vamos subir o RabbitMQ, o processo será o mesmo, entramos para fazer um novo deploy, o nome será <code>rabbitmq-heimdall</code>, e a 
imagem será <code>rabbitmq:alpine</code>, por fim, clicamos em Launch.
<br /><br />
Ao fim de todos os deploys, teremos um total de 3 aplicações rodando, deverá estar algo parecido com isso: 
<div align="center">
  <img src="./images/services-deployed.PNG" title="Serviços" />
</div>
<br />

# Subindo os módulos (Config, Gateway, API e Front-end)
Depois de termos subido todos os serviços que usaremos no nosso Heimdall, agora precisamos subir os módulos.
<br />
O primeiro módulo que subiremos será o do config, mas antes de tudo, você precisará criar um repositório Git onde ficarão as configurações 
do seu Heimdall, para isso, <a href="https://github.com/getheimdall/heimdall">entre no repositório do heimdall</a>, entre no diretório heimdall-config/src/main/resources/shared, 
veja que terão vários arquivos no formato <code>.yml</code>, seu repositório deverá ter todos eles exatamente com o nome que estão.
<br />
Feito o repositório já com os arquivos, precisamos atualizá-los com os nossos serviços, para isso, entre no arquivo <code>application-docker.yml</code>, 
deixe-o aberto pois precisaremos dele. Agora volte no Rancher, entre dentro de cada um dos serviços (postgres-heimdall, redis-heimdall e rabbitmq-heimdall) 
e copie o IP Address de todos eles. Vamos agora substituir colocando esses IP's lá no nosso config, o do postgres-heimdall colocaremos em <code>heimdall.datasource.serverName</code>, 
o do redis colocaremos em <code>heimdall.redis.host</code> e o do RabbitMQ colocaremos em <code>spring.rabbitmq.host</code>
<br /><br />
Após atualizados os dados, vamos agora subir o nosso módulo de <b>configuração</b>
