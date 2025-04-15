# threat_species
Functions to identify threatened species in a reference database
## PT
### fing_species 
A função find_species identifica espécies ameaçadas em um banco de dados de referência que contém as colunas Especie (nome da espécie) e Categoria (grau de ameaça), mesmo em casos de erros de grafia ou variações nos nomes. Ela utiliza os seguintes parâmetros:

    species: um vetor com os nomes das espécies a serem comparados.

    species_to_match: um data.frame com as colunas Especie (nomes das espécies de referência) e Categoria (grau de ameaça de cada espécie).

    max.distance (padrão: 0.05): distância máxima permitida para correspondências aproximadas, onde valores menores indicam maior similaridade.

A função retorna um data.frame com o nome original, o nome sugerido, a distância de edição e a categoria de ameaça, permitindo padronizar e validar nomes taxonômicos de forma eficiente.

## EN
### fing_species 
The find_species function identifies threatened species in a reference database containing the columns Especie (species name) and Categoria (threat level), even in cases of typos or name variations. It uses the following parameters:

    species: a vector with the species names to be compared.

    species_to_match: a data.frame with the columns Especie (reference species names) and Categoria (threat level for each species).

    max.distance (default: 0.05): the maximum allowable distance for approximate matches, where smaller values indicate greater similarity.

The function returns a data.frame containing the original name, the suggested name, the edit distance, and the threat category, enabling efficient standardization and validation of taxonomic names.
