rm(list=ls())
getwd()
setwd("C:/Users/karem.sastoque/Downloads")

ptes1 <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
head(ptes1)
summary(ptes1)
class(ptes1)

sapply(ptes1, class) 

str(ptes1)


colnames(ptes1)
names(ptes1)[names(ptes1) == "Cod.Carrera"] <- "CodCarrera"

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

ptes_192 <- merge(ptes1, programas_name, by="CodCarrera", all.x = TRUE)

#el siguiente elimina las filas de programas que cruzaron sin estudiantes
#ptes_192 <- ptes_192[-c(2903:2908),]

###############################################################
#ahora vamos a eliminar los registros de estudiantes que no estan o
#pertenecen a la modalidad virtual dejando solo los que contengan una "V" 
#al final del "CodCarrera" o sencillamente los que cruzaron con el 
#merge() anterior, que son los de la tabla de programas de virtual.
library(dplyr)
ptes_virt_192 <- ptes_192 %>%
  dplyr::filter(CodCarrera %in% programas_name$CodCarrera)

#y dejamos solo los valores unicos de estudiantes de virtual
ptes_virt_192_uniq <- ptes_virt_192 %>% distinct(codunico, .keep_all= TRUE)

library(xlsx)
write.csv(ptes_virt_192_uniq, file="ptes_192_hoy.csv")


####################################
#pegamos los numeros telefonicos y correo electronico de los estudiantes pendientes
#de pago de ODM con el fin de hacer seguimiento a su proceso de legalizacion y pago


estudiantes_dir <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
sapply(estudiantes_dir, class) 
str(estudiantes_dir)


colnames(estudiantes_dir)

names(estudiantes_dir)[names(estudiantes_dir) == "Cod.Carrera"] <- "CodCarrera"
columnas_elim <- c("ID", "Nombre", "Genero", "Direccion", "Jornada", "Nucleo", "Estrato", 
                  "Nombre.1", "Nombre.2", "Apellido.1", "Apellido.2", "Fecha.Nacimiento",
                  "X", "CodCarrera", "Tipo.ID", "Cohorte", "Mencion", "Estado")
estudiantes_dir <- estudiantes_dir[,!(names(estudiantes_dir) %in% columnas_elim)]


ptes_virt_192_uniq$Estudiante <- as.character(ptes_virt_192_uniq$Estudiante)
estudiantes_dir$Estudiante <- as.character(estudiantes_dir$Estudiante)
ptes_virt_192_uniq_dir <- merge(ptes_virt_192_uniq, estudiantes_dir, by="Estudiante", all.x = TRUE)

# Merging left and right: Data frames have columns "id" in common
#library(sqldf)
#mysqldatajoin <- sqldf("select left.*, right.* from left left join right on right.id = left.id")

rm(ptes1)
rm(ptes_192)
rm(ptes_virt_192)
rm(columnas_elim)

library(xlsx)
write.csv(ptes_virt_192_uniq, file="ptes_192_hoy_v2.csv")
