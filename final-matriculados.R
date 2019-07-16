rm(list=ls())
getwd()
setwd("C:/Users/karem.sastoque/Downloads")

ptes1 <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
head(ptes1)
summary(ptes1)
class(ptes1)

sapply(ptes1, class) 

str(ptes1)

rename(ptes1$Cod.Carrera, ptes1$CodCarrera)

#creamos la variable que nos dará el codigo unico por el cual
#vamos a empezar a limpiar los datos

ptes1$Estudiante <- as.character(ptes1$Estudiante)
ptes1$codunico <- paste(ptes1$Estudiante, as.character(ptes1$ODM), sep = "")
ptes1$Estudiante <- as.factor(ptes1$Estudiante)

#importamos los datos de los programas para conocer los nombres
#que ya viene en formato de excel documento .xls
#y pegarselos a los codigos que trae el .txt

library(readxl)                                         
programas_name <- as.data.frame(read_excel(file.choose(), col_names = TRUE))

ptes_191 <- merge(ptes1, programas_name, by="CodCarrera", all=TRUE)

###############################################################
#ahora vamos a eliminar los registros de estudiantes que no estan o
#pertenecen a la modalidad virtual dejando solo los que contengan una "V" 
#al final del "CodCarrera" o sencillamente los que cruzaron con el 
#merge() anterior, que son los de la tabla de programas de virtual.
library(dplyr)
ptes_virt_191 <- ptes_191 %>%
  dplyr::filter(CodCarrera %in% programas_name$CodCarrera)

#y dejamos solo los valores unicos de estudiantes de virtual
ptes_virt_191_uniq <- ptes_virt_191 %>% distinct(codunico, .keep_all= TRUE)

