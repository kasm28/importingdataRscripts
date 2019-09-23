rm(list=ls())
getwd()
setwd("C:/Users/karem.sastoque/Downloads")

estudiantes_dir <- as.data.frame(read.delim(file.choose(), sep="!", header=TRUE))
sapply(estudiantes_dir, class) 
str(estudiantes_dir)


colnames(estudiantes_dir)

estudiantes_dir <- estudiantes_dir[,-21]
names(estudiantes_dir)[names(estudiantes_dir) == "Cod.Carrera"] <- "CodCarrera"
