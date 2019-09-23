######################################################################################
###########################      TO DO :  VIRTUAL       ##############################
######################################################################################

########                       Matriculados Campus                           #########


#In this case, CAMPUS data does have the first row as a header 
#the first column is used to identify the student (sampling unit)
#by its ID without any other number (there might be another comlumn 
#called "estudiante" which contains the student ID and in some cases 
#is followed by a -01 or -02 depending on the program they are
#currently enrolled (or paying the enrollment) which can be found 
#in the second column. 

#The second column contains the code for the program and it is the key
#to merge with a table which contains the name, unit and faculty of the program.
#Which is the first filter we must do if we want to know students enrolled 
#at virtual programs modality.

#We are going to focus on the third and ninth column which contains 
#the student unique identifier and the number of the ODM issued respectively, 
#for this student (1st col), at this program (2nd col), specified 
#cohort (11th col). So, we are going to concatenate those 3rd and 9th cols
#into a new field at the end of the table to create a unique code so
#we can filter unique values by students and ODM generated for it, 
#because we have many rows duplicated by estudent and ODM which contains details 
#on the ODM, like discounts and many other charges that students are paying
#for the semester or cohort of studying.


#######################################################          NOTES       ######
#To concatenate words, inserting a . in between to words instead of a space.
#Make sure that any missing values in your data set are indicated with NA.


rm(list=ls())
getwd()
setwd("C:/Users/karem.sastoque/Downloads")

install.packages(c("data.table", "dplyr", "tydiverse"))

matriculados1 <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
head(matriculados1)
summary(matriculados1)
class(matriculados1)

sapply(matriculados1, class) 

str(matriculados1)

#creamos la variable que nos dará el codigo unico por el cual
#vamos a empezar a limpiar los datos

matriculados1$Estudiante <- as.character(matriculados1$Estudiante)
matriculados1$codunico <- paste(matriculados1$Estudiante, as.character(matriculados1$ODM), sep = "")
matriculados1$Estudiante <- as.factor(matriculados1$Estudiante)


#importamos los datos de los programas para conocer los nombres
#que ya viene en formato de excel documento .xls
#y pegarselos a los codigos que trae el .txt

library(readxl)                                         
programas_name <- as.data.frame(read_excel(file.choose(), col_names = TRUE))

matriculados_191 <- merge(matriculados1, programas_name, by="CodCarrera")
#Returns all rows from both tables, join records from the 
#left which have matching keys in the right table.

#si la ultima fila queda con nombre de programa pero vacia debemos activar
#la siguiente linea de codigo
#matriculados_191 <- matriculados_191[-c(#ultima fila),]

###############################################################
#ahora vamos a eliminar los registros de estudiantes que no estan o
#pertenecen a la modalidad virtual dejando solo los que contengan una "V" 
#al final del "CodCarrera" o sencillamente los que cruzaron con el 
#merge() anterior, que son los de la tabla de programas de virtual.
library(dplyr)
matric_virt_191 <- matriculados_191 %>%
  dplyr::filter(CodCarrera %in% programas_name$CodCarrera)

#y dejamos solo los valores unicos de estudiantes de virtual
matric_virt_191_uniq <- matric_virt_191 %>% distinct(codunico, .keep_all= TRUE)


#ESTE SERA EL ARCHIVO LIMPIO CON EL QUE SACAMOS EL REPORTE DIARIO 
#DE MATRICULADOS EN UMB VIRTUAL
#install.packages("xlsx")
#write.csv(matric_virt_191_uniq, file="matric_191_hoy.csv")

library(xlsx)
write.xlsx(matric_virt_191_uniq, file="Matric_191_UMB_Virtual_201908xx.xlsx", col.names = TRUE, row.names = FALSE)





########################################################################################
################   Tabla de matriculados por programa     ##############################
#buscamos hacer un subset con la suma de estudiantes matriculados por
#programa. Primero agrupamos todo por programa en matric_xprog_vir_191
#LA SIGUIENTE LINEA DE CODIGO NOS ORGANIZA EL DATASET AGRUPANDOLO POR PROGRAMA
#matric_vir_agrupada_191 <- group_by(matric_virt_191, Programa)

#y ahora sacamos los conteos de estudiantes (registros unicos en la tabla)
#por programa

matric_virt_191_uniq %>% group_by(Programa) %>% summarise(no_row = length(codunico))




#######################################################################################
############################   PARA BUSCAR UN ESTUDIANTE ESPECIFICO    ################
#######################################################################################

grep("16078138", matric_virt_191_uniq$Estudiante, perl = TRUE, value = FALSE)
#[1] 1200
print(matric_virt_191_uniq[1200,])