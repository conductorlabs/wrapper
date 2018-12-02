<div align="center">
  <img src="./images/rancher-logo.png" width="230" title="Rancher" />
</div>

# O que é Rancher?
Rancher é um orquestrador de containers que usa como base Kubernetes criado pela <a href="https://rancher.com/">Rancher Labs</a>.

# Instalação
Nesta documentação iremos abordar apenas a instalação do Rancher usando Single-Node, ou seja, iremos fazer um node em containers dentro do nosso servidor 
porém, saiba que o Rancher tem suporte para vários tipos de clouds, sendo elas Azure, Amazon, Google Cloud, entre outros...
<br />
Sem mais enrolação, vamos subir o Rancher com o seguinte comando:
```console
conductorlabs@pc:~$ docker run -d --restart=unless-stopped -p 8080:80 -p 9090:443 rancher/rancher:latest
```
Perceba que externalizamos duas portas, são elas a 8080 e 9090, não usamos 80 nem 443 do servidor pois essas portas estarão ocupadas com outros serviços 
do Rancher

<br />
Com isso, seu Rancher já terá subido, agora, entre no IP do seu servidor no browser seguido da porta 9090. Quando você entrar, terá uma tela de "boas-vindas", pedindo para você definir uma senha para o usuário "admin", após definir a senha, você terá que confirmar o IP do servidor do Rancher, aconselhamos que deixe o IP que já estiver preenchido, caso queira personalizar esse IP, fique à vontade.
