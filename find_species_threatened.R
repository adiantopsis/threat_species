# find_species ------------------------------------------------------------
# Encontre espécies ameacadas de extinção em seus dados baseado em uma lista de espécies
#
# A função find_species identifica espécies ameaçadas em um banco de dados de referência
# que contém as colunas Especie (nome da espécie) e Categoria (grau de ameaça), mesmo em 
# casos de erros de grafia ou variações nos nomes. Ela utiliza os seguintes parâmetros:
#   
# - species: um vetor com os nomes das espécies a serem comparados.
# 
# - species_to_match: um data.frame com as colunas Especie (nomes das espécies de referência)
# e Categoria (grau de ameaça de cada espécie).
# 
# - max.distance (padrão: 0.05): distância máxima permitida para correspondências aproximadas,
# onde valores menores indicam maior similaridade.
# 
# A função retorna um data.frame com o nome original, o nome sugerido, a distância de edição e a
# categoria de ameaça, permitindo padronizar e validar nomes taxonômicos de forma eficiente.
# Aqui eu forneço a lista de flora da Portaria MMA 148 de 2022 e a lista mais recente do 
# CNC Flora, mas também é possível utilizar essa função para busca em outras planilhas
# basta ela possuir colunas configuradas de maneira identica (com Especie e Categoria)

find_species <-function(species, species_to_match, max.distance=0.05){
  require(foreach)
  require(doParallel)

  
  num_cores <- parallel::detectCores() - 4
  cl <- makeCluster(num_cores)
  registerDoParallel(cl)
  
  sp_l <- foreach::foreach(x = 1:length(species), .combine = rbind) %dopar% 
    {
      sp_agrep <- agrep(species[x], species_to_match$Especie, 
                        value = TRUE, max.distance = max.distance)
      if (length(sp_agrep) > 0) {
        d <- as.numeric(adist(species[x], sp_agrep))
        categorias <- species_to_match$Categoria[match(sp_agrep, species_to_match$Especie)]
        
      } else {
        sp_agrep <- NA
        d <- NA
        categorias <- NA
      }
      sp_df <- data.frame(input_name = species[x], 
                          Suggested_name = sp_agrep, Distance = d, 
                          Categoria = categorias)
      
    } %>% drop_na(Suggested_name)
  stopCluster(cl)
  return(sp_l)
}


# find_iucn ---------------------------------------------------------------
# Encontre as espécies ameacadas de extinção em seus dados baseado na lista do IUCN
# 
# A função find_iucn busca o status de conservação de espécies na Lista Vermelha da IUCN 
# utilizando a API do IUCN Red List. Ela realiza consultas em paralelo para otimizar a eficiência e retorna um
# resumo do status de ameaça de cada espécie fornecida. Os parâmetros utilizados são:
#   
#   x: um vetor contendo os nomes das espécies a serem consultadas.
# 
# api_key: a chave de acesso à API da IUCN, necessária para autenticação e execução das consultas.
# 
# A função retorna um data.frame com duas colunas:
#   
#   input_name: o nome original da espécie consultada.
# 
#   IUCN: o status de ameaça obtido da IUCN, como "CR" (Criticamente em Perigo), "
#   EN" (Em Perigo), entre outros.
# 
# Essa função é útil para integrar informações de conservação em análises de biodiversidade,
# permitindo o acesso automatizado a dados confiáveis sobre o estado de ameaça das espécies.


find_iucn <- function(x, api_key) { 
  require(taxize)
  
  extract_code <- function(species) {
    if (is.list(species) && !is.null(species$red_list_category$code)) {
      return(species$red_list_category$code)
    } else if (is.character(species)) {
      return(species)
    } else {
      return(NA) 
    }
  }

  species_status <- taxize::iucn_summary(x = x, key = api_key, distr_detail=T)


species_codes <- sapply(species_status, extract_code) %>% data.frame(Status = .) %>% drop_na ()

species_codes <- data.frame(input_name = rownames(species_codes), "IUCN" = species_codes$Status)

return (species_codes)
}

