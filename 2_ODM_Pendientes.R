


########                       ODM-Pendientes Campus                           #########


#In this case, CAMPUS data does have the first row as a header 
#the first column is used to identify the student (sampling unit)
#by its ID without any other number (there might be another comlumn 
#called "estudiante" which contains the student ID and in some cases 
#is followed by a -01 or -02 depending on the program they are
#currently enrolled (or paying the enrollment) which can be found 
#in the second column. 

#The second column contains the code for the program and it is the key
#to merge with a table which contains the name, unit and faculty of the program.
#Which is the first filter we must do if we want to know students that are
#pending to legalize ODMs -odm has been issued but not payid or not being paid-
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
