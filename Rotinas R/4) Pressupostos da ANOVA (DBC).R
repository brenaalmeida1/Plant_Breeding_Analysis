########################################################################
###########                Rotina elaborada por              ###########
###########             Eric Vinicius Vieira Silva           ###########
###########              ericvinicius.vs@gmail.com           ###########
###########                     22/08/2019                   ###########
########################################################################


##------------------ PRESSUPOSTOS DA ANOVA PARA DBC ------------------##

# Os testes para as pressupossi��es do DBC s�o semelhantes aos do DIC.
# Entretanto, necess�rio transformar as nossas repeti��es em um fator 
# principal. De modo que:  Yij = m + Ti + Bj + eij

##---------------------------- Normalidade ---------------------------##

setwd("C:\\Users\\Usuario\\Desktop\\Plant_Breeding_Analysis") #Definir diret�rio ou Ctrl+Shift+H
dir()
dados<-read.table("exemplo3.txt", h=T)
str(dados) #Estrutura da tabela --> Trat INT?!?!
dados<-transform(dados, Trat=factor(Trat), Rep=factor(Rep)) #Transformando Trat e Rep em fatores!
str(dados) #Conferindo os fatores
summary(dados) #M�dia e m�diana dos dados.

# Para realizar as an�lises dos pressupostos � necess�rio extrair primeiramente os ERROS.

AOVDados<-aov(ABS ~ Trat + Rep, data = dados)
AOVDados$residuals #Extraindo os residuos/erros do nosso conjunto de dados

shapiro.test(AOVDados$residuals) # O teste de Shapiro-Wilk � um dos teste para analisar a 
                                 # Normalidade dos erros.
                                 # Aqui testamos a seguinte hipotese:
                                 # H0: Os erros seguem distribui��o Normal. Ou seja, queremos
                                 # aceitar a hipotese de nulidade, assim, desejamos o p-value
                                 # superior ao nivel de signific�ncia, exemplo p-value > 0.05


# Neste exemplo, de acordo com o teste de Shapiro-Wilk os erros seguem Distribui��o Normal

# � possivel an�lisar a Normalidade por meio de gr�ficos. Utilizaremos o pacote fBasics

install.packages("fBasics")
library(fBasics)

qqnormPlot(AOVDados$residuals) #Plotar o gr�fico com os residuos. 

histPlot(x = as.timeSeries(AOVDados$residuals)) #observar a distribui��o dos dados


##------------------------- Homocedasticidade ------------------------##

# O segundo pressuposto a ser verificado � a homogeneidade dos erros.

getwd() # Verificar o diret�rio que se est� trabalhando
dados


bartlett.test(AOVDados$residuals~Trat,data=dados) # O teste de Bartlett � um dos teste utilizados
                                                  # para aferir a homocedasticidade dos erros. 
                                                  # Semelhante ao teste de Normalidade, desejamos
                                                  # aceitar a hip�tese de nulidade
                                                  # H0: Os erros s�o homog�neos, assim, 
                                                  # desejamos o p-value superior ao nivel de 
                                                  # signific�ncia, exemplo p-value > 0.05

# Observa-se que para DBC o teste de homogeneidade de Bartlett deve ser realizado
# somente com os residuos, diferentemente do DIC onde a an�lise dos residuos ou
# dos dados retornam a mesma informa��o. Por qu�??

# Outra forma de verificar a homogeneidade � atraves do teste de ONeill e Mathews.
# Para tal, pode-se utilzar o pacote ExpDes.pt

install.packages("ExpDes.pt")
library("ExpDes.pt")

oneilldbc(dados$ABS, dados$Trat, dados$Rep) #Pressuposto atendido!

# Neste exemplo, de acordo com o teste de Bartlett e ONeill e Mathews os erros s�o homog�neos


##--------------------------- Independ�ncia --------------------------##

# Para verificar a Independ�ncia dos erros pode-se utilizar o pacote car

install.packages("car")    
library("car")

getwd() # Verificar o diret�rio que se est� trabalhando
dados

dwt(lm(AOVDados)) # Neste caso ser� utilizado o teste de Durbin-Watson
                  # a fun��o dentro do pacote car � dwt. 
                  # Deseja-se que os erros n�o apresentem autocorrela��o
                  # ou seja, os erros devem ser independentes
                  # H0: Os erros s�o independentes
                  # Dessa forma desejamos o p-value superior ao nivel de 
                  # signific�ncia, exemplo p-value > 0.05


# Os erros s�o independentes


##---------------------------- Aditividade ---------------------------##

# No modelo em DBC, al�m dos tratamentos tem-se o efeito de blocos como
# um dos efeitos principais do modelo. Sendo necess�rio realizar o teste
# da aditividade!

# Para verificar a Aditividade do modelo pode-se utilizar o pacote asbio

install.packages("asbio")
library(asbio)

getwd() # Verificar o diret�rio que se est� trabalhando
dados

tukey.add.test(dados$ABS,  dados$Rep, dados$Trat) # Neste caso ser� utilizado o 
                                                  # teste de Aditividade de Tukey
                                                  # H0: O modelo � aditivo
                                                  # Dessa forma desejamos o p-value 
                                                  # superior ao nivel de signific�ncia
                                                  # exemplo: p-value > 0.05



attach(dados) # Utilizando a fun��o attach/detach podemos fixar o objeto dados, simplificando
# para:

tukey.add.test(ABS, Rep, Trat)

detach(dados)

# O modelo � aditivo

##--------------------- Pressupostos n�o atendidos --------------------##

# Caso os pressupostos n�o sejam atendidos pode-se adotar algumas estr�tegias
# para submeter os dados � An�lise de Vari�ncia, uma delas � a transforma��o 
# de dados.

##-------------------------------  FIM  -------------------------------##