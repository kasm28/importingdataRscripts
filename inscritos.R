rm(list=ls())
getwd()

install.packages(c("sqldf", "gsubfn", "RSQLite", "proto", "dplyr", "xlsx"))

#Cargamos la base de datos de incritos en aulas o enrollments, de cursos, 
#de usuarios y de registros de ultimo ingreso de cada usuario de canvas.

enrollments <- as.data.frame(read.csv(file.choose(), sep=",", header=TRUE, encoding = "UTF-8"))
courses <- as.data.frame(read.csv(file.choose(), sep=",", header=TRUE, encoding = "UTF-8"))
users <- as.data.frame(read.csv(file.choose(), sep=",", header=TRUE, encoding = "UTF-8"))
ult_ingreso <- as.data.frame(read.csv(file.choose(), sep=",", header=TRUE, encoding = "UTF-8"))

sapply(enrollments, class)
sapply(courses, class)
sapply(users, class)
sapply(ult_ingreso, class)

#Trabajaremos sobre la base de datos de incritos como estudiantes en los cursos, 
#es decir con la data que contiene el dataframe (subset de enrollments) students, 
#a la cual debemos pegarle mas adelante informacion de los docentes encargados de 
#cada aula (subset de enrollments).

library(sqldf)
library(dplyr)

teachers <- as.data.frame(sqldf("select * from enrollments where role = 'teacher' and status = 'active'"))
teachers <- as.data.frame(teachers)
colnames(teachers)
sapply(teachers, class)

#tengo mas de un teacher por aula, el siguiente codigo deja solo un unico registro de profesor por aula.
teachers <- teachers %>% distinct(canvas_course_id, .keep_all= TRUE)

students <- as.data.frame(sqldf("select * from enrollments where role = 'student'"))
students <- as.data.frame(students)
colnames(students)
sapply(students, class)

#Necesitamos que nuestro informe salga de los datos de "students", por lo que va a 
#ser a este df que vamos a pegar todos los datos que necesitamos: 
#   De la tabla "courses" sacamos los nombres de los cursos, el estado del curso "status", 
#   fechas de inicio y finalizacion del curso "start_date" y "end_date".

inscritos <- as.data.frame(sqldf("select * from students left join courses on students.canvas_course_id = courses.canvas_course_id"))
#mysqldatajoin1 <- as.data.frame(mysqldatajoin1)
colnames(inscritos)

#quiero eliminar las columnas de la 5 a la 19 y del 21 al 24 y de la 28 a la 30
#o por nombres de columnas serian 

columnas_elim <- c("role", "role_id", "canvas_section_id", "section_id", "status", "canvas_associated_user_id", "associated_user_id", "created_by_sis", "base_role_type", "limit_section_privileges", "canvas_enrollment_id", "canvas_course_id..16", "course_id..17", "integration_id", "short_name", "canvas_account_id", "account_id", "canvas_term_id", "term_id", "course_format", "blueprint_course_id", "created_by_sis..30")

inscritos <- inscritos[,!(names(inscritos) %in% columnas_elim)]
colnames(inscritos)

#  De la tabla "teachers" sacamos los codigo canvas y cedula de los docentes
#  asociados a ese curso.

inscritos <- as.data.frame(sqldf("select * from inscritos left join teachers on inscritos.canvas_course_id = teachers.canvas_course_id"))
#mysqldatajoin1 <- as.data.frame(mysqldatajoin1)
colnames(inscritos)

columnas_elim <- c("canvas_course_id..9", "course_id..10", "role", "role_id", "canvas_section_id", "section_id", "status", "canvas_associated_user_id", "associated_user_id", "created_by_sis", "base_role_type", "limit_section_privileges", "canvas_enrollment_id")
inscritos <- inscritos[,!(names(inscritos) %in% columnas_elim)]
colnames(inscritos)

#  De la tabla "users" pegamos los nombres de los docentes al codigo canvas de su usuario.

names(inscritos)[names(inscritos) == "canvas_user_id..11"] <- "docente_canvas_id"
inscritos <- as.data.frame(sqldf("select * from inscritos left join users on inscritos.docente_canvas_id = users.canvas_user_id"))
#mysqldatajoin1 <- as.data.frame(mysqldatajoin1)
colnames(inscritos)

columnas_elim <- c("canvas_user_id..11", "user_id..12", "integration_id", "authentication_provider_id", "login_id", "first_name", "last_name", "sortable_name", "short_name", "email", "status", "created_by_sis")
inscritos <- inscritos[,!(names(inscritos) %in% columnas_elim)]
colnames(inscritos)

names(inscritos)[names(inscritos) == "canvas_user_id"] <- "student_canvas_id"
names(inscritos)[names(inscritos) == "user_id"] <- "student_cc"
names(inscritos)[names(inscritos) == "user_id..10"] <- "docente_cc"
names(inscritos)[names(inscritos) == "full_name"] <- "docente_name"
names(inscritos)[names(inscritos) == "status..6"] <- "course_status"
names(inscritos)[names(inscritos) == "start_date"] <- "course_start"
names(inscritos)[names(inscritos) == "end_date"] <- "course_end"
colnames(inscritos)

#Y el ultimo dato que necesito para completar el informe es la fecha de
#ultimo ingreso del estudiante que la encuentro en a tabla "ult_ingreso".

inscritos <- as.data.frame(sqldf("select * from inscritos left join ult_ingreso on inscritos.student_canvas_id = ult_ingreso.'user.id'"))
#mysqldatajoin1 <- as.data.frame(mysqldatajoin1)
colnames(inscritos)

columnas_elim <- c("user.id", "user.sis.id", "last.ip")
inscritos <- inscritos[,!(names(inscritos) %in% columnas_elim)]
colnames(inscritos)

library(xlsx)
write.xlsx(inscritos, file="C:/users/flamingo/Desktop/Work/UMB/Canvas/inscripciones2019xxXX.xlsx", col.names = TRUE, row.names = FALSE)

