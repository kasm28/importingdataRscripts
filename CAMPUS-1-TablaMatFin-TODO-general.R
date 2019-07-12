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
sapply(data1, class) 

#contamos los valores unicos para las variables estudiante y ODM 
count()

#creamos la variable que nos dará el codigo unico por el cual
#vamos a empezar a limpiar los datos
matriculados1['codigounico'] <- unite(matriculados1, matriculados1$codigounico, c(3:9, -4:-8)         verificar 
                                          
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

install.packages("tydiverse")

library(tidyverse)
# Remove duplicates based on "codunico" column
matric_vir_191 <- matriculados_191[!duplicated(matriculados_191$codunico), ]
#o se puede con el comando unique() que me deja un dataset con
#solo los datos unicos pero no nos da el mismo resultado?

install.packages("dplyr")
library(dplyr)
#Remove duplicate rows based on all columns:
#my_data %>% distinct()                                 
#Remove duplicate rows based on certain columns (variables):
#my_data %>% distinct(col1, other_col, col3, .keep_all = TRUE)
matric_vir_191 <- matriculados_191 %>% distinct(codunico, .keep_all= TRUE)



                                          
                                          
                                          
                                          
                       
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





