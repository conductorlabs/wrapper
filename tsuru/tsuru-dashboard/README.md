# Instalando o dashboard
O Dashboard do Tsuru é uma aplicação feita à parte, que é necessário que seja feito deploy como qualquer outra aplicação, e é com o CLI que 
instalamos o dashboard, é bem fácil! 
Primeiro precisamos adicionar a plataforma Python no nosso Tsuru: 
```console
conductorlabs@pc:~$ tsuru platform-add python
```

Após isso, vamos criar nossa aplicação: 
```console
conductorlabs@pc:~$ tsuru app-create tsuru-dashboard python -t time
```

Após criar a aplicação, basta fazermos o deploy da imagem do dashboard na aplicação: 
```console
conductorlabs@pc:~$ tsuru app-deploy -a tsuru-dashboard -i tsuru/dashboard
```

Depois de baixar a imagem e fazer o deploy, seu dashboard já está pronto e você poderá acessar com o link gerado pelo tsuru para aplicação que pode ser encontrado da seguinte forma: 
```console
conductorlabs@pc:~$ tsuru app-info -a tsuru-dashboard
```
