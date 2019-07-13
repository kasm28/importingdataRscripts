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
setwd("<location of our dataset>")

library("data.table")
# Check if you already installed the package
any(grepl("data.table", installed.packages()))


matriculados1 <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
head(matriculados1)
summary(matriculados1)
class(matriculados1)
sapply(matriculados1, class) 

str(matriculados1)
#contamos los valores unicos para las variables estudiante y ODM 

as.data.frame(table(matriculados1))

#v <- c(matriculados1$estudiante, matriculados1$ODM)
#aggregate(data.frame(count = v), list(value = v), length)

#creamos la variable que nos dará el codigo unico por el cual
#vamos a empezar a limpiar los datos
#matriculados1['codigounico'] <- unite(matriculados1, matriculados1$codigounico, c(3:9, -4:-8)         verificar 

library(dplyr)
#states.df <- data.frame(name = as.character(state.name),
#                        region = as.character(state.region), 
#                        division = as.character(state.division))
#res = mutate(states.df,
#   concated_column = paste(name, region, division, sep = '_'))
matriculados1['codunico'] <- mutate(matriculados1,
                                       codunico = paste( matriculados1$estudiante, matriculados1$ODM, sep= "."))


#importamos los datos de los programas para conocer los nombres
#que ya viene en formato de excel documento .xls
#y pegarselos a los codigos que trae el .txt

library(readxl)                                         
programas_name <- as.data.frame(read_excel(file.choose(), header=TRUE)))

matriculados_191 <- merge(matriculados1, programas_name, by="CodCarrera", all=TRUE)
#Returns all rows from both tables, join records from the 
#left which have matching keys in the right table.

##########################
#ahora vamos a eliminar los registros de estudiantes que no estan o
#pertenecen a la modalidad virtual dejando solo los que contengan una "V" 
#al final del "CodCarrera" o sencillamente los que cruzaron con el 
#merge() anterior, que son los de la tabla de programas de virtual.

#primero creamos un vector con los codigos de programa de la tabla de 36 programas
programs_virt <- programas_name$CodPrograma
programs_virt


#y ese vector se lo paso como condicion al comando keep o drop rows
install.packages("dplyr")
library(dplyr)
library(magrittr)

#to keep rows that appear on "programas_name" -ended with V (including the exception V1324)
#and delete anything else
matric_virt_191 <- matriculados_191 %>%
  dplyr::filter(CodCarrera %in% progrms_virt)

#OR to keep rows which do not appear on "programas_name" -do not end with V (expluding the exception V1324)
#matric_virt_191 <- matriculados_191 %>%
#  dplyr::filter(!CodCarrera %in% progrms_virt)

install.packages("tydiverse")

library(tidyverse)
# Remove duplicates based on "codunico" column
#matric_virt_191 <- matriculados_191[!duplicated(matriculados_191$codunico), ]

#matric_virt_191_uniq <- matric_virt_191[!duplicated(matric_virt_191$codunico), ]

#o se puede con el comando unique() que me deja un dataset con
#solo los datos unicos pero no nos da el mismo resultado?

library(dplyr)
#Remove duplicate rows based on all columns:
#my_data %>% distinct()                                 
#Remove duplicate rows based on certain columns (variables):
#my_data %>% distinct(col1, other_col, col3, .keep_all = TRUE)
# sin haber filtrado por programas virtuales sería: 
#matric_virt_191 <- matriculados_191 %>% distinct(codunico, .keep_all= TRUE)

matric_virt_191_uniq <- matric_virt_191 %>% distinct(codunico, .keep_all= TRUE)

#buscamos hacer un subset con la suma de estudiantes matriculados por
#programa. Primero agrupamos todo por programa en matric_xprog_vir_191

matric_vir_agrupada_191 <- group_by(matric_vir_191, programa)

#y ahora sacamos los conteos de estudiantes (registros unicos en la tabla)
#por programa

matric_vir_xprog_191 <- summarize(matric_vir_agrupada_191, count = n(),)#dist = mean(Distance, na.rm = T), delay = mean(ArrDelay, na.rm = T
matric_vir_xprog_191

#sin haber hecho la parte de valores unicos tambiens e pudo haber sacado esta misma tabla


#https://www3.nd.edu/~steve/computing_with_data/24_dplyr/dplyr.html

matric_vir_xprog_191_2 <- group_by(matriculados_191, programa)
summarise(matric_vir_xprog_191_2,  = n_distinct(TailNum), flights = n())

                                  
                          


                                          
                                          
                                          
                                          
                       
#N.ID   TEXT
#CodCarrera    TEXT
#Estudiante    TEXT
#Nombre     TEXT
#Servicio ODM    TEXT 
#Fecha ODM     DATE
#Monto
#Saldo
#ODM     TEXT    
#Tipo Servicio     TEXT
#Cohorte      
#Semestre
#Genero      
#Jornada
#Estado     
#Mencion
#Instrumento de Pago
#Fecha
#Estructura Academica     TEXT
#Nucleo
#Periodo
#Tipo de Cuenta
#Entidad      TEXT
#Cuenta     TEXT





