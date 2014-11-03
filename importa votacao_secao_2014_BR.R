# Instala e carrega pacotes #
install.packages("reshape2")
install.packages("benford.analysis")
library(reshape2)
library(benford.analysis)

# Importa base de dados de votação por seção eleitoral #
temp <- tempfile()
download.file("http://agencia.tse.jus.br/estatistica/sead/odsele/votacao_secao/votacao_secao_2014_BR.zip",temp)
votacao <- read.table(unz(temp, "votacao_secao_2014_BR.txt"), sep = ";" )
unlink(temp)
colnames(votacao) <- c("DATA_GERACAO","HORA_GERACAO","ANO_ELEICAO","NUM_TURNO","DESCRICAO_ELEICAO","SIGLA_UF","SIGLA_UE","CODIGO_MUNICIPIO","NOME_MUNICIPIO",
                       "NUMERO_ZONA","NUM_SECAO","CODIGO_CARGO","DESCRICAO_CARGO","NUM_VOTAVEL","QTDE_VOTOS")

# Extrai dados do 2o turno #
turno2 <- votacao[which(votacao[,"NUM_TURNO"]==2),]

# Cria base de dados votos_dilma por zona eleitoral #
votos2turnoSecao <- dcast(data = turno2, formula =  SIGLA_UF + NUMERO_ZONA + NUM_SECAO ~ NUM_VOTAVEL, fun.aggregate = sum, value.var = "QTDE_VOTOS")
votos_dilma <- votos2turnoSecao[,c("SIGLA_UF","NUMERO_ZONA","NUM_SECAO","13")]
colnames(votos_dilma) <- c("uf","zona","secao","votos")
votos_dilma$votos <- as.numeric(votos_dilma$votos)

# Cria base de dados de eleitores (utilizando soma dos votos por seção como proxy de eleitores)
votos2turnoSecao$eleitores <- apply(votos2turnoSecao[,c("13","45","95","96")],1,sum)
eleitorado <- votos2turnoSecao[,c("SIGLA_UF","NUMERO_ZONA","NUM_SECAO","eleitores")]
colnames(eleitorado) <- c("uf","zona","secao","eleitores")
eleitorado$eleitores <- as.numeric(eleitorado$eleitores)

