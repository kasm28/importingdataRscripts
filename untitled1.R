rm(programas_name)
  
rm(matric_virt_191)
rm(matriculados_191)
rm(matriculados1)

rm(matric_virt_191_uniq)
rm(ptes_virt_192_uniq)

rm(ptes_192)
rm(ptes_virt_192)
rm(ptes1)














fra_campus_virt <- arrange(fra_campus_virt, Identificacion)

#by_id <- group_by(fra_campus_virt, Identificacion)
#summarise(by_id, min(fecha))
#filter

ultim_pago <- fra_campus_virt %>%
  group_by(Identificacion) %>%
  dplyr::filter(min(dif_fechas_meses))