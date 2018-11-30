<div align="center">
  <a href="https://github.com/getheimdall/heimdall"><img src="./images/logo-heimdall.png" width="80" /></a>
  <a href="http://www.conductor.com.br/"><img src="./images/logo-conductor.png" width="300" /></a>
</div>
<br />

# Subindo o <a href="https://getheimdall.io">getheimdall.io</a> no <a href="https://tsuru.io">tsuru</a>
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

De acordo com a ordem, todos os módulos devem ser iniciados para que tenhamos o orquestrador em si, e é isso que faremos para inseri-lo no Tsuru

# Pré-configurações
Antes de começarmos a subir o Heimdall no Tsuru, precisamos ter instaladas as plataformas necessárias para rodar o mesmo, são elas: **java** e **nodejs**

# Subindo o Config
Primeiro de tudo, vamos criar uma aplicação no Tsuru para o config: 
```console
conductorlabs@pc:~$ tsuru app-create heimdall-config java -t time
```

Para subirmos o config, precisamos antes de tudo ter um repositório onde estarão todas as configurações do Heimdall, para assim, apontarmos o config para recuperar todos os dados de lá. Para definirmos de onde virão os dados, basta adicionarmos um environment com o link do repositório:
```console
conductorlabs@pc:~$ tsuru env-set SPRING_CLOUD_CONFIG_SERVER_GIT_URI=http://github.com/exemplo/repositorio -a heimdall-config
```

Após definirmos o environment do git das configurações, vamos deixar o perfil do Spring como docker, com o objetivo de tirar o perfil native, pois com o perfil native, a aplicação busca pelos arquivos de configurações dentro da pasta shared localmente: 
```console
conductorlabs@pc:~$ tsuru env-set SPRING_PROFILES_ACTIVE=docker -a heimdall-config
```

Após isso, podemos fazer o deploy do config para deixá-lo disponível: 
```console
conductorlabs@pc:~$ tsuru -a heimdall-config -i getheimdall/heimdall-config
```

# Subindo o Gateway
Após subirmos o config, precisamos subir o gateway, tanto o gateway quanto a API dependem do config para que possam subir, então, precisaremos do IP do config para poder acessá-lo e defini-lo nos environments dos dois.
Então, vamos criar a aplicação do gateway: 
```console
conductorlabs@pc:~$ tsuru app-create heimdall-gateway java -t time
```

Depois de criarmos a aplicação, precisamos definir o IP do config no environment da aplicação: 
```console
conductorlabs@pc:~$ tsuru env-set SPRING_CLOUD_CONFIG_URI=http://ip-do-config:8888/ -a heimdall-gateway
```

Definida a environment de configuração, vamos colocar o perfil do Spring como docker: 
```console
conductorlabs@pc:~$ tsuru env-set SPRING_PROFILES_ACTIVE=docker -a heimdall-gateway
```

Após isso, podemos fazer o deploy da aplicação: 
```console
conductorlabs@pc:~$ tsuru app-deploy -a heimdall-gateway -i getheimdall/heimdall-gateway
```

<b>Tudo certo, agora temos o Gateway UP! :blush:</b>

# Subindo a API
Para subir a API o processo é muito parecido com o Gateway, vamos lá. Primeiro vamos criar a aplicação da API: 
```console
conductorlabs@pc:~$ tsuru app-create heimdall-api java -t time
```

Após criarmos a aplicação da API, vamos setar o environment da URL onde está rodando a config, da mesma forma que fizemos com o Gateway: 
```console
conductorlabs@pc:~$ tsuru env-set SPRING_CLOUD_CONFIG_URI=http://ip-do-config:8888/ -a heimdall-api
```

Depois de definir a aplicação do config, vamos setar o perfil do Spring como docker: 
```console
conductorlabs@pc:~$ tsuru env-set SPRING_PROFILES_ACTIVE=docker -a heimdall-api
```

Após isso, podemos fazer o deploy da aplicação: 
```console
conductorlabs@pc:~$ tsuru app-deploy -a heimdall-api -i getheimdall/heimdall-api
```

<b>Agora nossa API já está rodando! :grin:</b>

# Subindo o Front-end
A última parte da nossa jornada é subir o front-end do Heimdall, para subí-la, precisaremos baixar o <a href-"https://github.com/getheimdall/heimdall">repositório do heimdall</a>, após isso, 
entre dentro do repositório na sua máquina e entre na pasta heimdall-frontend, nele, vamos primeiro precisar voltar a versão do front para a versão
1.8.0-stable, para isso, vamos usar o comando: 
```console
conductorlabs@pc:~$ git checkout tags/1.8.0-stable
```

Voltamos a versão pois a versão que estamos usando com as imagens do DockerHub do Heimdall estão mais desatualizadas que o código do front-end que baixamos, 
por sesse motivo, voltamos a versão, seguindo em frente, vamos alterar o arquivo <b>.env.production</b>, nele é onde ficam as environments que 
conectam o front-end com a API: 
```console
conductorlabs@pc:~$ vim .env.production
```

Vamos alterar nele o address, colocando a URL da API que já está rodando, e a porta, que será 8989 (que é a porta padrão do tsuru, caso você tenha mudado, 
altere para a porta que você colocou nas configurações). Após essa alteração, salve o arquivo e instale as dependências do NodeJS: 
```console
conductorlabs@pc:~$ sudo npm install
```

Após instalar as dependências, por garantia, vamos rodar a aplicação para ver se está tudo certo:
```console
conductorlabs@pc:~$ npm start
```

Vendo que a aplicação está funcionando normalmente, vamos fazer o build da aplicação usando o comando: 
```console
conductorlabs@pc:~$ npm run build
```

Após terminar o build da aplicação, vamos criar uma imagem Docker e enviar para o DockerHub (caso não tenha, registre-se e crie um repositório para que possa fazer o push da sua imagem): 
```console
conductorlabs@pc:~$ docker build -t usuario/nome-do-repositorio:latest .
conductorlabs@pc:~$ docker push usuario/nome-do-repositorio:latest
```

Após ter dado o push na nossa imagem no nosso DockerHub, podemos começar a fazer o deploy dela no nosso Tsuru, primeiramente, vamos criar nossa aplicação: 
```console
conductorlabs@pc:~$ tsuru app-create heimdall-frontend nodejs -t time
```

Depois de criada a aplicação, vamos já fazer o deploy de nossa imagem nela, pois lembre-se que já alteramos todos os environments antes de buildar a imagem, 
ou seja, ela já está toda configurada para funcionar perfeitamente com nossa API: 
```console
conductorlabs@pc:~$ tsuru app-deploy -a heimdall-frontend -i usuario/nome-do-repositorio:latest
```

Agora basta entrar no browser com a URL da aplicação heimdall-frontend, e ver se tudo está correto, caso não saiba a URL, basta rodar o comando: 
```console
conductorlabs@pc:~$ tsuru app-info -a heimdall-frontend
```

<div align="center">
  <b>E é isso, seu Heimdall está UP, basta aproveitar! :smiley::smiley:</b>
</div>
<br />
