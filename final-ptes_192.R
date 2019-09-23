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
write.xlsx(ptes_virt_192_uniq, file="ODM-Pendientes_191_UMB_Virtual_201908xx.xlsx", col.names = TRUE, row.names = FALSE)


################################################################################
#pegamos los numeros telefonicos y correo electronico de los estudiantes pendientes
#de pago de ODM con el fin de hacer seguimiento a su proceso de legalizacion y pago


estudiantes_dir <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
sapply(estudiantes_dir, class)
str(estudiantes_dir)
colnames(estudiantes_dir)


names(estudiantes_dir)[names(estudiantes_dir) == "Cod.Carrera"] <- "CodCarrera"
columnas_elim <- c("Jornada", "Nucleo", "Estrato", "Nombre.1", "Nombre.2", 
                   "Apellido.1", "Apellido.2", "Fecha.Nacimiento",
                   "X", "Tipo.ID", "Cohorte", "Mencion", "Estado")
estudiantes_dir <- estudiantes_dir[,!(names(estudiantes_dir) %in% columnas_elim)]
colnames(estudiantes_dir)

#ptes_virt_192_uniq$Estudiante <- as.factor(ptes_virt_192_uniq$Estudiante)
#estudiantes_dir$Estudiante <- as.factor(estudiantes_dir$Estudiante)
sapply(estudiantes_dir, class)


rm(columnas_elim)
#ptes_virt_192_uniq_dir <- merge(ptes_virt_192_uniq, estudiantes_dir, by="Estudiante", all.x = TRUE)

# Merging left and right: Data frames have columns "id" in common
install.packages("sqldf")
install.packages("gsubfn")
install.packages("RSQLite")
install.packages("proto")
library(sqldf)

#mysqldatajoin1 <- as.data.frame(sqldf("select * from ptes_virt_192_uniq left join estudiantes_dir on ptes_virt_192_uniq.Estudiante = estudiantes_dir.Estudiante"))
#mysqldatajoin1 <- as.data.frame(mysqldatajoin1)
colnames(mysqldatajoin1)


ptes_virt_192_uniq_sql_dir <- mysqldatajoin1[, -(28:30)]
colnames(ptes_virt_192_uniq_sql_dir)
ptes_virt_192_uniq_sql_dir <- ptes_virt_192_uniq_sql_dir[, -18]
ptes_virt_192_uniq_sql_dir <- ptes_virt_192_uniq_sql_dir[, -10]
colnames(ptes_virt_192_uniq_sql_dir)


#library(sqldf)
#mysqldatajoin <- sqldf("select left.*, right.* from left left join right on right.id = left.id")

install.packages("rJava", "xlsx")
library(rJava)
library(xlsx)
#write.csv(mysqldatajoin1, file="ptes_192_hoy_v2.csv")
write.xlsx2(ptes_virt_192_uniq_sql_dir, file = "ptes_19x_hoy_v2.xlsx", 
            sheetName ="matric_19x_2019xxxx",  col.names = TRUE, row.names = FALSE)

rm(ptes1)
rm(ptes_192)
rm(ptes_virt_192)

