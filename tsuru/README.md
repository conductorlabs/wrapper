# O que é o tsuru?
Tsuru é um orquestrador feito pela globo.com com a intenção de facilitar a vida do desenvolvedor ao fazer deploy de uma aplicação

# Instalação
* Antes de tudo, clone este repositório, para que possa ter acesso aos arquivos: 
```console
conductorlabs@pc:~$ git clone https://github.com/conductorlabs/wrapper.git
```
* Entre na pasta tsuru que se encontra dentro do repositório: 
```console
conductorlabs@pc:~$ cd tsuru/
```
* Execute o script build.compose.sh: 
```console
conductorlabs@pc:~$ ./build-compose.sh
```
* Aguarde e verifique se os containers irão subir: 

* <b><i>Atenção: Às vezes o container da API do tsuru pode cair, e assim você terá que restartar o container (ele cai geralmente porque sobe antes do MongoDB, assim, dá erro)</i></b>

* Após isso, estar tudo ok, mas você precisará cadastrar o usuário root do tsuru, para isso, rode diretamente o comando para criação do usuário: 
```console
conductorlabs@pc:~$ docker exec -it hash-do-container-da-api tsurud root-user-create example@mail.com
```

* Apenas mais uma coisa para tudo ficar pronto, execute um comando para dar permissão ao usuário git aos repositórios do Gandalf: 
```console
conductorlabs@pc:~$ docker exec -it hash-do-container-do-gandalf chown git:git /var/lib/gandalf/repositories
```

* **Tudo certo, agora o tsuru está rodando perfeitamente em docker na sua máquina!**

# Autenticando na API
* Antes de mais nada, precisamos nos autenticar no próprio tsuru, para isso, precisamos antes ter o client instalado, o client pode ser encontrado em https://github.com/tsuru/tsuru-client/releases/
* Já com o client instalado, vamos adicionar nosso target da seguinte forma
```console
conductorlabs@pc:~$ tsuru target-add default http://url-do-servidor:8080 -s
```
* Após adicionar o target, vamos finalmente fazer nossa autenticação na API
```console
conductorlabs@pc:~$ tsuru login
```
* Coloque seu usuário e senha e **voilà**, estamos autenticados no nosso servidor tsuru!

# Adicionando pool's e node's
Para usufruir do tsuru, precisamos de um nó onde ficarão nossos containers que serão criados pelo próprio tsuru, e é isso que faremos agora

* Primeiro, vamos adicionar uma pool de nodes: 
```console
conductorlabs@pc:~$ tsuru pool-add nome-da-pool -p -d
```

* Depois disso, vamos adicionar um nó na nossa pool recém criada: 
```console
conductorlabs@pc:~$ tsuru node-add pool=nome-da-pool address=http://node1:2375 --register
```
* <i>Note que colocamos node1 no address, esse node é o que subimos no **docker-compose** do tsuru, mas caso você tenha outros, basta adicionar</i>

* Pronto, já temos uma pool com um nó adicionado nela, já podemos realizar ações do tsuru :blush:

# Adicionando plataformas no tsuru
Usamos as plataformas para definirmos que uma aplicação que criarmos tem uma plataforma base, por exemplo: A API do Heimdall é feito em Java, então adicionamos a plataforma Java, e quando criamos a aplicação da API do Heimdall, avisamos ao tsuru que essa aplicação é Java

* Para adicionar uma plataforma é muito simples
```console
conductorlabs@pc:~$ tsuru platform-add nome-da-plataforma
```
* <i>Algumas plataformas conhecidas são: <b>nodejs, java, go, python, ruby</b></i>

# Criando times e aplicações
Podemos gerenciar melhor nossas aplicações se definirmos times para gerenciá-las, dessa forma, cada time terá permisso somente sobre **X** aplicações

* Para criarmos um time, usamos o comando: 
```console
conductorlabs@pc:~$ tsuru team-create nome-do-time
```

* Após criarmos o time, podemos criar nossa aplicação e atribuí-la para um time gerenciá-la
```console
conductorlabs@pc:~$ tsuru app-create nome-da-aplicação plataforma-da-aplicação -t time-para-gerenciar
```

* <b>Pronto, agora já temos uma aplicação que é gerenciada por um time</b>

# Fazendo deploy em uma aplicação
Podemos fazer deploy em uma aplicação não só de uma forma, pode ser usando um diretório, um arquivo, uma imagem, entre outros...

* Para fazermos um deploy usando um diretório todo, fazemos desta forma: 
```console
conductorlabs@pc:~$ tsuru app-deploy . -a nome-da-app
```
* <i>Veja que colocamos o ".", isso significa que o tsuru irá, com base na plataforma da aplicação, buildar tudo que tiver na pasta para subir o deploy</i>

* Para fazermos um deploy usando um arquivo apenas, fazemos desta forma:
```console
conductorlabs@pc:~$ tsuru app-deploy arquivo.go -a nome-da-app
```
* <i>Neste exemplo, usamos um arquivo com extensão em go, mas poderia ser py, rb, java, entre outros... </i>

* Para fazermos um deploy usando uma imagem no <a href="http://www.dockerhub.com/">DockerHub</a>: 
```console
conductorlabs@pc:~$ tsuru app-deploy -a nome-da-aplicação -i caminho/da-imagem
```

# Definindo environments em aplicações
Em algumas aplicações precisaremos definir environments, e o tsuru nos ajuda muito com isso, bora lá? :laughing:

* Para pegar os environments de uma aplicação é bem simples, basta rodarmos o comando: 
```console
conductorlabs@pc:~$ tsuru env-get -a nome-da-app
```

* Para definirmos um environment de uma aplicação, basta executarmos o comando: 
```console
conductorlabs@pc:~$ tsuru env-set NOME_DO_ENVIRONMENT=valor-do-environment -a nome-da-aplicação
```
