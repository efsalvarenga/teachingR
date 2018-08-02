nota 1

---
  title: "Tomo 02 Processamento de Dados"
subtitle: 'Da série Aprendendo R com o Estêvão"'
author: "EFS Alvarenga"
date: "18/07/2018"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(tidyr)
```

## Antes de tudo

### Vetores

Diferentes funções podem ser utilizadas para a criar vetores.

```{r}
v1 <- 1                   # vetor com comprimento 1
v1
v2 <- c(1, 2, 3, 4)       # função básica para criar (e combinar) vetores
v2
1:10                      # sequência de 1 a 10
seq(1, 10)                # sequência de 1 a 10
seq(1, 10, by = 2)        # sequência de 1 a 10, 2 a 2
rep(1, 5)                 # repete 1, 5 vezes
rep(c(1,2,3), 5)          # repete o vetor c(1,2,3) 5 vezes
```

#### Diferentes tipos de dados

O R pode armazenar diversos tipos de dados.
Vetores e matrizes se restringem ao mesmo tipo de dados em toda a estrutura, enquanto listas e data frames permitem estruturas com tipos mistos.

```{r}
vlog  <- c(FALSE, TRUE, TRUE)           # vetor de dados lógicos
vtex  <- c('x', 'oil', 'water', 'gas')  # vetor de texto
vint  <- c(1210, 1141, 121, 500)        # vetor de inteiros
vreal <- c(5.4, 1.88, 7.54854)          # vetor de reais
```

Caso o usuário (ou alguma função) especifique um vetor com tipos de dados mistos, o R tentará armazenar tudo no tipo mais abrangente (geralmente texto).

```{r}
vmix  <- c(1, 2, 'êpa')
```

Diversas funções permitem que o usuário teste o tipo de dado armazenado em um objeto.

```{r}
is.logical(vlog)
is.character(vint)
is.character(vmix)
is.numeric(vtex)
```

### Data frames

Data frames são tabelas quadradas.
Estruturalmente funcionam como uma lista de vetores de mesmo comprimento, mas com a flexibilidade de possuírem tipos de dados diferentes.

```{r}
data.frame(letras = c("A", "B", "C"),numeros = c(3,7,5), logicos = c(T, F, T))
data.frame(letras = c("A", "B", "C"),
           numeros = c(3,7,5),
           logicos = c(T, F, T))
letras  <- c("A", "B", "C")
numeros <- c(3,7,5)
logicos <- c(T, F, T)
data.frame(letras, numeros, logicos)
```

Observe que existem diversas formas de se fazer a mesma coisa em R (como em qualquer outra linguagem de programação).
Observe também que, ao atribuir valores a um objeto utilizei o caractere `<-` enquanto para nomear variáveis nos argumentos de uma função utilizei `=`.
Foi uma escolha puramente estética, já que `=` pode ser utilizado como sinal de atribuição também.

#### Salvando e carregando data frames.

Data frames são estruturas flexíveis mas que guardam restrições que os permitem facilmente serem salvos e carregados como arquivos.
Arquivos csv são preferenciais devido a sua fácil interpretação por diversos aplicativos.

```{r}
df1 <- data.frame(letters = letras,
                  numbers = numeros,
                  logical = logicos)

write.table(x = df1,
            file = 'df1.csv',
            sep = ';',
            row.names = FALSE)

df2 <- read.table(file = 'df1.csv',
                  sep = ';',
                  header = TRUE)
```


### Processando dados utilizando o R Básico

A função `read.csv2()` é uma função irmã da `read.table()`.
O arquivo abaixo contém o histórico de produção de petróleo de uma seleção de alguns país e regiões do mundo, a partir de 1971.
Esses dados são baseados nos [dados da OECD](https://data.oecd.org/energy/crude-oil-production.htm):
  
  > Crude oil production is defined as the quantities of oil extracted from the ground after the removal of inert matter or impurities. It includes crude oil, natural gas liquids (NGLs) and additives. This indicator is measured in thousand tonne of oil equivalent (toe).Crude oil is a mineral oil consisting of a mixture of hydrocarbons of natural origin, yellow to black in colour, and of variable density and viscosity. NGLs are the liquid or liquefied hydrocarbons produced in the manufacture, purification and stabilisation of natural gas. Additives are non-hydrocarbon substances added to or blended with a product to modify its properties, for example, to improve its combustion characteristics (e.g. MTBE and tetraethyl lead).Refinery production refers to the output of secondary oil products from an oil refinery.

```{r}
ProdPetroleo <- read.csv2('//Petrobras.biz/Petrobras/AGUP/AGUP_RES-EE/NP-2/Campos/Lula/Reservatorios/04. Eng. Reservatórios/09. Estudos Especiais/DataScience/Curso R/OilProdPorPais.csv')
```

Existem diversas funções para examinar os dados importados.

```{r}
head(ProdPetroleo)                # examina as primeiras linhas de um objeto
ProdPetroleo[1:10,c(1,3,4,5:7)]   # examina pedaços específicos de um objeto
is.data.frame(ProdPetroleo)       # confere se o objeto é um data frame
dim(ProdPetroleo)                 # exibe as dimensões do objeto
str(ProdPetroleo)                 # exibe a estrutura do objeto
summary(ProdPetroleo)             # apresenta uma  estatística descritiva simples das colunas
ProdPetroleo$BRA                  # extrai um vetor de uma coluna específica
ProdPetroleo[,3]                  # a mesma operação pode ser realizada com a localização do vetor de interesse
names(ProdPetroleo)               # retorna o nome das colunas
```

```{r eval=FALSE, include=TRUE}
View(ProdPetroleo)                # abre uma aba com o data viewer do objeto
```

A coluna da Albânia foi importada como valor inteiro, enquanto todas as outras foram importadas como reais.
Podemos ajustar isso facilmente.

```{r}
ProdPetroleo$ALB <- as.numeric(ProdPetroleo$ALB)
str(ProdPetroleo)
```

Podemos realizar operações simples.

```{r}
USAp <- mean(ProdPetroleo$USA)
USAp
RUSp <- mean(ProdPetroleo$RUS)
RUSp
RUSp <- mean(ProdPetroleo$RUS, na.rm = TRUE)
RUSp
SAUp <- mean(ProdPetroleo$SAU)
SAUp
WLDp <- mean(ProdPetroleo$WLD)
WLDp
WLDp - USAp - RUSp - SAUp
(USAp + RUSp + SAUp)/WLDp
```

### Processando dados utilizando o **tidyverse**

_The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures._
Leia mais sobre o tidyverse [aqui](https://www.tidyverse.org/)

```{r eval=FALSE, include=TRUE}
install.packages("tidyverse")
```

Inicialmente vamos utilizar uma biblioteca do tidyverse.

```{r eval=FALSE, include=TRUE}
library(dplyr)
```

O `dplyr` é utilizado para encadear funções em uma rotina de execução.
O `dplyr` utiliza uma inversão entre função e seus argumentos, baseado no operador `%>%` do `magittr`.
Dessa forma `f(x)` pode ser representado por `x %>% f`, o que facilita a leitura de grandes cadeias de execução.

```{r}
sum(rep(seq(from=5, length=4, by=2),times=2))

seq(from=5, length=4, by=2) %>%
  rep(., times = 3) %>%
  sum(.) # o "." é interpretado como o argumento anterior, e normalmente pode ser omitido
```

Além do operador em cadeia, o `dplyr` utiliza de funções denominadas **verbos** para a execução de operações como seleção, filtro, agrupamento, resumo, etc.

NB: Estou encadeando a função `head()` para evitar que toda a tabela seja impressa.
Excluindo este último elo da cadeia retorna todos os dados do data.frame.

```{r}
ProdPetroleo %>%
  head()
ProdPetroleo %>%
  filter(ano > 2010)
```

Por experiência sei que a função `select()` do `dplyr` conflita com outros outras bibliotecas (possuem o mesmo nome, mas executam processos diferentes).
Para evitar erros que dependem das bibliotecas carregas no sistema, é possível chamar funções especificando o pacote, utilizando o operador `::`.
Dessa forma, a forma robusta de se escrever o código acima é:
  
  ```{r}
ProdPetroleo %>%
  dplyr::select(ano, BRA, EU28, USA, WLD) %>%
  head()
```

Filtros podem ser utilizados para verificar regiões específicas da tabela.

```{r}
ProdPetroleo %>%
  filter(ano > 2010)
```

A função `mutate()` é utilizada para criar novas variáveis (ou atualizar variáveis existentes)

```{r}
ProdPetroleo %>%
  dplyr::select(ano, BRA, EU28, USA, WLD) %>%
  mutate(decada = 10*floor(ano/10))
```

Se após o cálculo da década encadearmos um agrupamento e então calcular médias para cada década podemos observar melhor a evolução da produção de petróleo dos diversos países.

```{r}
ProdPetroleo %>%
  mutate(decada = 10*floor(ano/10)) %>%
  group_by(decada) %>%
  summarise(mediaALB = mean(ALB, na.rm=TRUE),
            mediaBRA = mean(BRA, na.rm=TRUE),
            mediaEU28 = mean(EU28, na.rm=TRUE),
            mediaIRN = mean(IRN, na.rm=TRUE),
            mediaRUS = mean(RUS, na.rm=TRUE),
            mediaSAU = mean(SAU, na.rm=TRUE),
            mediaUSA = mean(USA, na.rm=TRUE),
            mediaWLD = mean(WLD, na.rm=TRUE))
```

Outra biblioteca do tidyverse que é muito útil na análise de dados é o `tidyr`

```{r eval=FALSE, include=TRUE}
library(tidyr)
```

As funções `gather()` e `spread()` permitem facilmente transformar tabelas largas (como a que estamos utilizando até agora) em tabelas longas que seguem as regras de bancos de dados.
Para informação detalhada sobre esse processo, visite o artigo [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf) de Hadley Wickham.

```{r}
ProdPetroleoTabLonga <- ProdPetroleo %>%
  gather(pais,producao,-ano)
ProdPetroleoTabLonga %>% head()
```

```{r}
ProdPetroleoTabLonga %>%
  spread(pais, producao) %>%
  head()
```

Com uma tabela longa, o cálculo das médias por década fica simplificado, utilizando a função `group_by()`

```{r}
ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  group_by(decada, pais) %>%
  summarise(mediaProd = mean(producao, na.rm=TRUE))
```

Para visualizar da mesma forma que anteriormente, utilizamos o `spread()`.

```{r}
ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  group_by(decada, pais) %>%
  summarise(mediaProd = mean(producao, na.rm=TRUE)) %>%
  spread(pais, mediaProd)
```

NB: Tabelas largas são úteis para a visualização humana de dados.
Em compensação, tabelas longas são preferenciais para cálculos computacionais.
Portanto dominar o `gather()` e `spread()` é muito útil no processo de análise de dados.

A função `distinct()` retorna a combinação única de valores entre colunas (ou os valores únicos de uma coluna).

```{r}
ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  dplyr::select(decada) %>%
  distinct()
ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  dplyr::select(pais) %>%
  distinct()
ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  dplyr::select(decada,pais) %>%
  distinct() %>%
  head(12)                                # selecionei apenas os 12 primeiros, por brevidade
```

Para organizar os dados em ordem crescente ou decrescente utilize `arrange()` ou `arrange(desc())`, respectivamente.

```{r}
ProdPetroleoTabLonga %>%
  group_by(pais) %>%
  summarise(mediaProd = mean(producao, na.rm=TRUE)) %>%
  arrange(desc(mediaProd))
```

Para combinar tabelas distintas em uma única tabela, utilize os **join()** baseados em banco de dados.
_Joins_ são como a função `vlookup()` ou `procv()` do Excel turbinadas!
  Para uma descrição completa dessas operações veja [SQL Joins](https://www.devmedia.com.br/sql-join-entenda-como-funciona-o-retorno-dos-dados/31006).

Para exemplificar, vamos criar duas tabelas baseadas na `ProdPetroleoTabLonga` e executar diversos _joins_.

```{r}
tab1 <- ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  group_by(decada, pais) %>%
  summarise(mediaProd = mean(producao, na.rm=TRUE)) %>%
  filter(pais %in% c('BRA','EU28','USA'))
# %in% filtra um vetor (ou coluna) que contém valores presentes em outro vetor
tab1
tab2 <- ProdPetroleoTabLonga %>%
  mutate(decada = 10*floor(ano/10)) %>%
  group_by(decada, pais) %>%
  summarise(mediaProd = mean(producao, na.rm=TRUE)) %>%
  filter(pais %in% c('RUS','USA'))
tab2
tab1 %>%
  inner_join(tab2)
tab1 %>%
  left_join(tab2)
tab1 %>%
  right_join(tab2)
tab1 %>%
  full_join(tab2)
```

### Exercício sugerido

O arquivo da produção de petróleo utilizado foi criado com base num banco de dados disponível abertamente em [link]('https://stats.oecd.org/sdmx-json/data/DP_LIVE/.OILPROD.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en').
Este arquivo original não está no formato do que utilizamos nesse tutorial.
Um bom exercício é transformá-lo de acordo com o objetivo do estudo.
Abaixo incluo os passos que utilizei.

```{r}
tabela <- read.table('https://stats.oecd.org/sdmx-json/data/DP_LIVE/.OILPROD.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en',
                     header = TRUE,
                     sep = ',') %>%
  dplyr::select(-INDICATOR,-SUBJECT,-MEASURE,-FREQUENCY,-Flag.Codes) %>%
  rename(pais = `ï..LOCATION`,
         ano = TIME,
         valor = Value)
tabela2 <- tabela %>%
  filter(valor > 0,
         ano > 1970,
         pais %in% c('WLD','SAU','USA','RUS','IRN','EU28','BRA','ALB')) %>%
  tidyr::spread(pais,valor)
```


### Observações

#### Lidando com datas (e _datetimes_)

Datas e _datetimes_ são interpretadas de forma diferente entre o Excel e a maior parte das linguagens de programação.
Enquanto o Excel trata a todos como o mesmo tipo de objeto, sendo horas dentro de um dia interpretadas como frações, o R utiliza duas classes distintas.
A classe **Date** (utilize a função `as.Date()` para criar objetos dessa classe) guarda apenas datas, como valores inteiros entre o dia e a origem (definida como 01/01/1970).
Já a classe **POSIXt** (utilize a função `as.POSIXct()` ou `as.POSIXlt()`) guarda horas, minutos e segundos.
Essas classes são altamente intercambiáveis entre si.
Para detalhes , consulte o tutorial [Handling date-times in R](http://biostat.mc.vanderbilt.edu/wiki/pub/Main/ColeBeck/datestimes.pdf) de Cole Beck.



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

