

nota 2


---
  title: "Tomo 03 Vizualização"
subtitle: 'Da série Aprendendo R com o Estêvão"'
author: "EFS Alvarenga"
date: "23/07/2018"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(ggridges)
```

## Antes de tudo

O R possui uma biblioteca para criação de gráficos no pacote básico.
Entretanto, as suas capacidades são muito limitadas se comparadas com o `ggplot2`.
Por esse motivo nesse tutorial explora apenas o segundo.

## ggplot2

O `ggplot2` é baseado na proposta [A Layered Grammar of Graphics](http://vita.had.co.nz/papers/layered-grammar.pdf) de Hadley Wickham.

Esse tutorial vai utilizar os mesmos dados do anterior.
Como `ggplot2` trabalha melhor com a estrutura de banco de dados, vamos utilizar novamente o `gather()` para transformar os dados.

```{r}
ProdPetroleo <- read.csv2('//Petrobras.biz/Petrobras/AGUP/AGUP_RES-EE/NP-2/Campos/Lula/Reservatorios/04. Eng. Reservatórios/09. Estudos Especiais/DataScience/Curso R/OilProdPorPais.csv')

ProdPetroleoTabLonga <- ProdPetroleo %>%
  gather(pais,producao,-ano)
```

### Séries temporais

O primeiro gráfico é uma simples série temporal para a produção de petróleo no Brasil.
É possível encadear comandos do `dplyr` passando-os ao `ggplot2`.
Assim que a cadeia de comandos do `ggplot2` inicia, o encadeamento passa a ser com o sinal `+`.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais == 'BRA') %>%
  ggplot(aes(x = ano, y = producao)) +
  geom_line()
```

No comando acima, a função `aes()` se refere a aesthetics (estética).
Essa função passa ao `ggplot2` quais variáveis serão utilizadas em cada uma das dimensões do gráfico.
Embora os gráficos sejam bi-dimensionais, temos diversas dimensões possíveis além do x e y, como cores, tamanhos, formatos, tipo de linha, etc.
Todas essas dimensões podem ser exploradas pela função `aes()`.

Em seguida, após definir quais variáveis serão utilizadas, uma função que define o tipo do gráfico é chamada.
No primeiro exemplo anterior utilizamos a `geom_line()`.
Poderíamos ter escolhidos pontos, ao invés de linhas através da `geom_point()`.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais == 'BRA') %>%
  ggplot(aes(x = ano, y = producao)) +
  geom_point()
```

Um exemplo do uso de cores como uma dimensão adicional é através do argumento `colour`.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('BRA','USA','SAU')) %>%
  ggplot(aes(x = ano, y = producao, colour = pais)) +
  geom_line()
```

### Histogramas

Para ver como o formato da distribuição da produção da Arábia Saudita durante essa série temporal, utilizaremos o `geom_hist()`.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('SAU')) %>%
  ggplot(aes(producao)) +
  geom_histogram()
```

O agrupamento acima não parece adequado.
O padrão é `bins = 30` mas talvez um número menor seja melhor.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('SAU')) %>%
  ggplot(aes(producao)) +
  geom_histogram(bins = 7)
```

Enquanto isso, a distribuição dos EUA tem a seguinte forma.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('USA')) %>%
  ggplot(aes(producao)) +
  geom_histogram(bins = 7)
```

Para ver ambos os países juntos:
  
  ```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('USA','SAU')) %>%
  ggplot(aes(producao, fill = pais)) +
  geom_histogram(bins = 7)
```

Para ver ambos os países em diferentes facetas no mesmo gráfico:
  
  ```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('USA','SAU')) %>%
  ggplot(aes(producao, fill = pais)) +
  geom_histogram(bins = 7) +
  facet_wrap(~pais)
```

Lembre-se que nem todos os tipos de gráfico apresentam a relação com o tempo, como a série temporal faz.
O histograma é um exemplo disso.

### Boxplots

Os mesmos dados do gráfico anterior, mas apresentados no formato de boxplots, se dá por meio da função `geom_boxplot()`.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais %in% c('USA','SAU')) %>%
  ggplot(aes(y = producao, x = pais)) +
  geom_boxplot()
```

Para adicionar os pontos, além do boxplot, adicione o `geom_point()` ao gráfico.
Aqui vamos alterar o filtro para observar mais países.
Note a desigualdade `!=` para isso.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais != 'WLD') %>%
  ggplot(aes(y = producao, x = pais)) +
  geom_boxplot() +
  geom_point()
```

A função `geom_jitter()` permite evitar que os pontos fiquem todos alinhados ou em cima uns dos outros.
Incluindo cores para os países o gráfico fica um pouco mais alegre.

```{r}
ProdPetroleoTabLonga %>%
  filter(pais != 'WLD') %>%
  ggplot(aes(y = producao, x = pais)) +
  geom_boxplot(aes(fill = pais)) +
  geom_jitter()
```

A função `coord_flip()` alterna os eixos (sem alterar os argumentos na função original).

```{r}
ProdPetroleoTabLonga %>%
  filter(pais != 'WLD') %>%
  ggplot(aes(y = producao, x = pais)) +
  geom_boxplot(aes(fill = pais)) +
  geom_jitter() +
  coord_flip()
```

De forma a manter um pouco da visão temporal podemos criar boxplots com a produção agrupada por década.
Com algumas configurações simples obtemos um gráfico mais limpo visualmente.

```{r}
ProdPetroleoTabLonga %>%
  mutate(decada = as.factor(10*floor(ano/10))) %>%
  filter(pais %in% c('USA','SAU','RUS')) %>%
  ggplot(aes(y = producao, x = decada)) +
  theme_minimal() +
  geom_boxplot(aes(colour = pais), fill = 'white')
```

### Scatterplot

Olhando novamente a série temporal, aparentemente existe uma correlação negativa entre a produção dos EUA e da Arábia Saudita entre 1980 e 2010.
O gráfico abaixo verifica essa observação.
Note que pelo gradiente de cor utilizado é possível observar a direção da tendência de produção dos dois países.
Formas, cores, etc. são técnicas valorosas para aumentar o número de dimensões representadas em um gráfico.

```{r}
ProdPetroleo %>%
  filter(ano > 1980 & ano < 2010) %>%
  ggplot(aes(x = USA, y = SAU)) +
  theme_minimal() +
  geom_point(aes(colour=ano)) +
  ggtitle('Produção dos EUA vs. Arábia Saudita') +
  ylab('Produção da Arábia Saudita') +
  xlab('Produção dos EUA')
```

A função `geom_smooth()` permite fitar visualmente um relação entre duas variáveis.
O argumento `method = lm` garante o uso de um modelo linear.

```{r}
ProdPetroleo %>%
  filter(ano > 1980 & ano < 2010) %>%
  ggplot(aes(x = USA, y = SAU)) +
  theme_minimal() +
  geom_point(aes(colour=ano)) +
  ggtitle('Produção dos EUA vs. Arábia Saudita') +
  ylab('Produção da Arábia Saudita') +
  xlab('Produção dos EUA') +
  geom_smooth(method = lm)
```

### Painel de gráficos

O gráfico de painéis faz parte da biblioteca de extensão do `ggplot2` chamada `GGally`.
É um gráfico muito útil para explorar variáveis, apresentando a densidade da distribuição, correlações e scatterplots num diagrama matricial.

```{r eval=FALSE, include=TRUE}
library(GGally)
```

```{r}
ProdPetroleo %>%
  select(BRA,USA,SAU) %>%
  ggpairs()
```

### Gráficos de dunas

Gráficos de dunas são um tipo especial de gráficos de densidade.
São bem informativos, guardando o formato da distribuição de valores e permitindo a comparação de vários grupos.

```{r eval=FALSE, include=TRUE}
library(ggridges)
```

```{r}
ProdPetroleoTabLonga %>%
  mutate(decada = as.factor(10*floor(ano/10))) %>%
  filter(pais != 'WLD') %>%
  ggplot(aes(x = producao, y = pais)) +
  theme_minimal() +
  geom_density_ridges(aes(fill = pais))
```

Customizações adicionais podem ser feitas: paleta de cores, fonte, eixos, título, etc.

```{r}
windowsFonts(Times=windowsFont("Times New Roman"))
ProdPetroleoTabLonga %>%
  mutate(decada = as.factor(10*floor(ano/10))) %>%
  filter(pais != 'WLD') %>%
  ggplot(aes(x = producao, y = pais)) +
  theme_minimal() +
  geom_density_ridges(aes(fill = pais), colour = 'gray') +
  scale_fill_brewer(palette="Set2") +
  theme(text=element_text(family = 'Times'),
        legend.position = 'none') +
  labs(title="Gráfico de dunas \nProducao de oleo por país", x ="Producao", y = "Pais")
```

