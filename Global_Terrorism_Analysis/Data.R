library(plyr)
library(dplyr)
library(tidyr)
library(readxl)

dados_raw <- read_xlsx("data/globalterrorism.xlsx")

# Tratamento dos dados

# Criando coluna de data
dados_raw$Data <- paste(dados_raw$iday,dados_raw$imonth,dados_raw$iyear,sep = '-')
dados_raw$Data <- as.Date(dados_raw$Data, format = '%d-%m-%Y')

# Seleção das varíaveis úteis
dados_clean <- dados_raw %>%
  select(!c(imonth,iday,suicide,location,natlty1_txt,corp1,summary))

# Removendo valores NA (mantendo apenas as linhas com todos valores preenchidos)
dados_clean <- dados_clean %>% drop_na()

# Filtrando por casos onde houve mortes
dados_clean <- dados_clean[dados_clean$nkill > 0, ]

#-----------------------------
## Agrupamentos por país

ataques_paises <- dados_clean %>%
  group_by(country_txt,iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(ataques_paises) = c('País','Ano', 'Ataques', 'Mortes', 'Media')

ataques_paises$Ano <- as.factor(ataques_paises$Ano)

ataques_paises$País[ataques_paises$País == 'Democratic Republic of the Congo'] <- 'Congo'

#-----------------------------
## Agrupamento por tipo de ataque

tipo_ataque <- dados_clean %>%
  group_by(attacktype1_txt,iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(tipo_ataque) = c('Tipo_Ataque','Ano', 'Ataques', 'Mortes', 'Media')

#------------------------------
## Agrupamento por tipo do alvo

tipo_alvo <- dados_clean %>%
  group_by(targtype1_txt,iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(tipo_alvo) = c('Tipo_Alvo','Ano', 'Ataques', 'Mortes', 'Media')

#-----------------------------
## Agrupamento por grupo terrorista

ataques_grupo <- dados_clean %>%
  group_by(gname,iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(ataques_grupo) = c('Grupo_Ataque','Ano', 'Ataques', 'Mortes', 'Media')

#------------------------------
## Agrupamento por tipo de arma

tipo_arma <- dados_clean %>%
  group_by(weaptype1_txt,iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(tipo_arma) = c('Tipo_Arma','Ano', 'Ataques', 'Mortes', 'Media')

tipo_arma$Tipo_Arma[tipo_arma$Tipo_Arma == "Vehicle (not to include vehicle-borne explosives, i.e., car or truck bombs)"] <- 'Vehicle'

#--------------------------------
# Gráfico de Area

area_chart <- dados_clean %>%
  group_by(iyear) %>%
  summarise(n_ataques = n(),
            n_mortes = sum(nkill),
            media = round(mean(nkill), 1))

colnames(area_chart) = c('Ano', 'Ataques', 'Mortes', 'Media')

#-----------------------------

# write.csv(dados_clean, "data/dados_clean.csv", row.names = FALSE)
# 
# write.csv(area_chart, "data/area_chart.csv", row.names = FALSE)
# 
# write.csv(ataques_grupo, "data/ataques_grupo.csv", row.names = FALSE)
# 
# write.csv(ataques_paises, "data/ataques_paises.csv", row.names = FALSE)
# 
# write.csv(tipo_alvo, "data/tipo_alvo.csv", row.names = FALSE)
# 
# write.csv(tipo_arma, "data/tipo_arma.csv", row.names = FALSE)
# 
# write.csv(tipo_ataque, "data/tipo_ataque", row.names = FALSE)