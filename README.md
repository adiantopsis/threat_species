# threat_species
Aqui são apresentadas ferramentas desenvolvidas para automatizar a busca por espécies ameaçadas de extinção utilizando o R, otimizando análises de biodiversidade e conservação.

* A primeira função, find_species, realiza buscas por correspondência para identificar o grau de ameaça (categoria) das espécies de um vetor em um banco de dados conhecido. Aqui disponibilizarei quatro bancos (veja a pasta data), ambos em .csv: a lista nacional espécies da flora ameaçadas de extinção (Portaria MMA nº 148 de 2022), lista de flora ameaçada no Rio Grande do Sul (Decreto nº 52.109 de 2014), plantas raras do Brasil (GIULIETTI et al., 2009) e a lista mais recente do Centro Nacional de Conservação da Flora (CNCFlora).

* A segunda função, find_iucn, automatiza a consulta ao status de conservação das espécies na Lista Vermelha da IUCN, acessando diretamente o portal oficial (IUCN Red List). Para utilizá-la, é necessário obter uma chave de API, que pode ser solicitada em https://api.iucnredlist.org/.

Essas ferramentas permitem a integração de dados confiáveis em estudos de conservação, facilitando a análise de espécies ameaçadas de forma rápida e precisa.

## PT
### fing_species 
A função find_species identifica espécies ameaçadas em um banco de dados de referência que contém as colunas Especie (nome da espécie) e Categoria (grau de ameaça), mesmo em casos de erros de grafia ou variações nos nomes. Ela utiliza os seguintes parâmetros:

* species: um vetor com os nomes das espécies a serem comparados.

* species_to_match: um data.frame com as colunas Especie (nomes das espécies de referência) e Categoria (grau de ameaça de cada espécie).

* max.distance (padrão: 0.05): distância máxima permitida para correspondências aproximadas, onde valores menores indicam maior similaridade.

A função retorna um data.frame com o nome original, o nome sugerido, a distância de edição e a categoria de ameaça, permitindo padronizar e validar nomes taxonômicos de forma eficiente.

Exemplo de uso: 
```r

    path <- "Path/To/File" #Preencha com o caminho até o local em que a função está armazenada
    source(file.path(path, "find_species_threatened.R"))
    ameacadas_br <- read.csv("data/portaria_MMA_148.csv", header = T, sep = ";")
    ameacadas_cnc <- read.csv("data/cnc_flora_v2020.csv", header = T, sep = ";")
    ameacadas_rs <- read.csv("data/ameacadas_rs.csv", header = T, sep = ";")
    my_sp <- c("Abarema cochliacarpos", "Apuleia leiocarpa")
    find_species(my_sp, ameacadas_br, distance= .1)
    find_species(my_sp, ameacadas_rs, distance= .1)
    find_species(my_sp, ameacadas_cnc, distance= .1)
```
### Bancos de dados
Os bancos de dados disponibilizados aqui estão em constante atualização. Você pode usar suas versões mais recentes através do seguinte código:

```r
  ameacadas_br <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/portaria_MMA_148_22.csv", 
                        fileEncoding = "UTF-8", sep=";", header = T)
  ameacadas_cnc <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/cnc_flora_v2020.csv", 
                        fileEncoding = "UTF-8", sep=";", header = T)
  ameacadas_rs <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/ameacadas_rs.csv",
                        fileEncoding = "UTF-8", sep=";", header = T)
```
Assim como você pode acessar a versão mais recente das funções através de: 
```r
source("https://raw.githubusercontent.com/adiantopsis/threat_species/main/find_species_threatened.R")
```

### find_iucn
A função find_iucn busca o status de conservação de espécies na Lista Vermelha da IUCN utilizando a API do IUCN Red List. Ela realiza consultas em paralelo para otimizar a eficiência e retorna um resumo do status de ameaça de cada espécie fornecida. Os parâmetros utilizados são:

* x: um vetor contendo os nomes das espécies a serem consultadas.

* api_key: a chave de acesso à API da IUCN, necessária para autenticação e execução das consultas.

A função retorna um data.frame com duas colunas:

* input_name: o nome original da espécie consultada.

* IUCN: o status de ameaça obtido da IUCN, como "CR" (Criticamente em Perigo), "EN" (Em Perigo), entre outros.

Essa função é útil para integrar informações de conservação em análises de biodiversidade, permitindo o acesso automatizado a dados confiáveis sobre o estado de ameaça das espécies.

Exemplo de uso: 

```r

    path <- "Path/To/File" #Preencha com o caminho até o local em que a função está armazenada
    source(file.path(path, "find_species_threatened.R"))
    my_api <- "My API" #Preencha com sua API obtida cadastrando-se em: https://api.iucnredlist.org/
    my_sp <- c("Abarema cochliacarpos", "Apuleia leiocarpa")
    find_iucn(my_sp, api_key = my_api)
```

## EN
### find_species 
The find_species function identifies threatened species in a reference database containing the columns Especie (species name) and Categoria (threat level), even in cases of typos or name variations. It uses the following parameters:

  *  species: a vector with the species names to be compared.

   * species_to_match: a data.frame with the columns Especie (reference species names) and Categoria (threat level for each species).

* max.distance (default: 0.05): the maximum allowable distance for approximate matches, where smaller values indicate greater similarity.

The function returns a data.frame containing the original name, the suggested name, the edit distance, and the threat category, enabling efficient standardization and validation of taxonomic names.

Usage: 
```r

    path <- "Path/To/File" #specify the path where the .R file is stored
    source(file.path(path, "find_species_threatened.R"))
    ameacadas_br <- read.csv("data/portaria_MMA_148.csv", header = T, sep=";")
    ameacadas_cnc <- read.csv("data/cnc_flora_v2020.csv", header = T, sep = ";")
    ameacadas_rs <- read.csv("data/ameacadas_rs.csv", header = T)
    my_sp <- c("Abarema cochliacarpos", "Apuleia leiocarpa")
    find_species(my_sp, ameacadas_br, distance= .1)
    find_species(my_sp, ameacadas_rs, distance= .1)
    find_species(my_sp, ameacadas_cnc, distance= .1)
```
    

### find_iucn
The find_iucn function retrieves the conservation status of species from the IUCN Red List using the IUCN Red List API. It performs parallel queries to optimize efficiency and returns a summary of the threat status for each species provided. The parameters used are:

*    x: a vector containing the species names to be queried.

*    api_key: the API key for the IUCN, required for authentication and execution of queries.

The function returns a data.frame with two columns:

*    input_name: the original name of the queried species.

 *   IUCN: the threat status retrieved from the IUCN, such as "CR" (Critically Endangered), "EN" (Endangered), among others.

This function is useful for integrating conservation information into biodiversity analyses, enabling automated access to reliable data on species threat statuses.

Usage: 

```r

    path <- "Path/To/File" #specify the path where the .R file is stored
    source(file.path(path, "find_species_threatened.R"))
    my_api <- "My API" #Fill in with your API key obtained by registering at: https://api.iucnredlist.org/
    my_sp <- c("Abarema cochliacarpos", "Apuleia leiocarpa")
    find_iucn(my_sp, api_key = my_api)
```

### Dataset 
The databases provided here are continuously updated. You can use their most recent versions through the following code:

```r
  ameacadas_br <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/portaria_MMA_148_22.csv", 
                        fileEncoding = "UTF-8", sep=";", header = T, sep = ";")
  ameacadas_cnc <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/cnc_flora_v2020.csv", 
                        fileEncoding = "UTF-8", sep=";", header = T, sep = ";")
  ameacadas_rs <- read.csv("https://raw.githubusercontent.com/adiantopsis/threat_species/main/data/ameacadas_rs.csv",
                        fileEncoding = "UTF-8", sep=";", header = T, sep = ";")
```
You can also access the most recent version of the functions through:

```r
source("https://raw.githubusercontent.com/adiantopsis/threat_species/main/find_species_threatened.R")
```
