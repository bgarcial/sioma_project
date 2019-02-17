#Paquetes a Instalar
install.packages("corrplot")




#Librerias a utilizar
library(corrplot)


#Importacion de datos
#datos = read.csv('SiomaDataset_28_weeks.csv', sep = ",")
datos = read.csv('../data/processed/sioma-inputs-output-unified_complete_28_weeks.csv', sep = ",")
datos = datos[-(6117:7801),]

#Analizando la correlaci?n entre los datos
corr = cor(datos)
corrplot(corr)

#Mirando Correlaciones Individuales
Peso = datos[,38]

#Luz
Luz = datos[,1]

Luz.mod = c()
for (i in 1:20){
  Luz.mod = cbind(Luz.mod,Luz^i)
}

corr1 = cor(Peso,Luz.mod)

#Encontramos que la luz^7 tiene una mayor correlacion con el peso del racimo del banano

#Precipitacion
precip = datos[,2]

prec.mod = c()
for (i in 1:20){
  prec.mod = cbind(prec.mod,precip^i)
}

corr2 = cor(Peso,prec.mod)

#Temperatura
temp = datos[,3]

temp.mod = c()
for (i in 1:20){
  temp.mod = cbind(temp.mod,temp^i)
}

corr3 = cor(Peso,temp.mod)


#Viento
viento = datos[,3]

viento.mod = c()
for (i in 1:20){
  viento.mod = cbind(viento.mod,viento^i)
}

corr4 = cor(Peso,viento.mod)


Modificaciones1 = cbind(t(corr1),t(corr2),t(corr3),t(corr4))
write.csv(Modificaciones1,'mod1.csv')




Direccion = datos[,5]*1+datos[,6]*2+datos[,7]*3+datos[,8]*4+datos[,9]*5+datos[,10]*6+datos[,11]*7+datos[,12]*8

Direccion2 = cbind(Direccion, datos[,5:12])
corrdir = cor(Peso,Direccion2)
write.csv(corrdir,'Direccion.csv')



#Nivel Freatico
corr0 = c()
for(i in 13:37){
  nivelF = c()
  for(j in 1:10){
    nivelF = cbind(nivelF,datos[,i]^j)
  }
  corr0 = rbind(corr0, cor(Peso,nivelF))
}
corr0 = t(corr0)

write.csv(corr0,"NivelF.csv")


############################################################################
############# Definicion de los conjuntos para trabajar ####################
############################################################################

train = datos[1:4893,]
test = datos[4894:6116,]

#Regresion Lineal

#Utilizando Step

Variables = datos
Variables = Variables[,-38]

Regresion = lm('pesoRacimo~?..Luz+Precip+Temp+Viento+E+N+NE+NO+O+S+SE+SO+PORVL2N1+PORVL2N2+PORVL4N1+PORVL5N1+
PORVL6N1+PORVL7N1+PORVL8N1+PORVL9N1+PORVL10N1+PORVL13N1+PORVL14N1+PORVL15N1+PORVL16N1+
   PORVL16N2+PORVL18N1+PORVL18N2+PORVL18N3+PORVL18N4+PORVL21N1+PORVL21N2+PORVL21N3+PORVL21N4+
   PORVL21N5+PORVL24N1+PORVL24N2', train)

summary(Regresion)

prediccion = predict(Regresion, test, se.fit = TRUE)
valores_p = prediccion$fit

Error = as.matrix(test[,38] - valores_p) 

ecm = t(Error)%*%Error/1223

ind =  !(test[,38]  == 0)
ErrorPorcentual = 100*abs(test[ind,38] - valores_p[ind])/test[ind,38]
ErrorPorcentualPromedio = mean(ErrorPorcentual)


plot(test[,38],valores_p, xlab = "Real",ylab = "Pronostico")
abline(0,1, lty=2, col='blue') 

#Modificando el Dataset
datos2 = datos

datos2[,1] = datos[,1]^7
datos2[,3] = datos[,3]^6
datos2[,4] = datos[,4]^6

datos2[,14] = datos[,14]^10
datos2[,16] = datos[,16]^2
datos2[,17] = datos[,17]^2
datos2[,21] = datos[,21]^10
datos2[,22] = datos[,22]^5
datos2[,23] = datos[,23]^2
datos2[,27] = datos[,27]^4
datos2[,28] = datos[,28]^8
datos2[,29] = datos[,29]^2
datos2[,30] = datos[,30]^9
datos2[,31] = datos[,31]^9
datos2[,35] = datos[,35]^9
datos2[,37] = datos[,37]^7

train2 = datos2[1:4893,]
test2 = datos2[4894:6116,]


Regresion2 = lm('pesoRacimo~?..Luz+Precip+Temp+Viento+E+N+NE+NO+O+S+SE+SO+PORVL2N1+PORVL2N2+PORVL4N1+PORVL5N1+
PORVL6N1+PORVL7N1+PORVL8N1+PORVL9N1+PORVL10N1+PORVL13N1+PORVL14N1+PORVL15N1+PORVL16N1+
               PORVL16N2+PORVL18N1+PORVL18N2+PORVL18N3+PORVL18N4+PORVL21N1+PORVL21N2+PORVL21N3+PORVL21N4+
               PORVL21N5+PORVL24N1+PORVL24N2', train2)

summary(Regresion2)

prediccion2 = predict(Regresion2, test2, se.fit = TRUE)
valores_p2 = prediccion2$fit


Error2 = as.matrix(test2[,38] - valores_p2) 

ecm2 = t(Error2)%*%Error2/1223

ind2 =  !(test2[,38]  == 0)
ErrorPorcentual2 = 100*abs(test2[ind2,38] - valores_p2[ind2])/test2[ind2,38]
ErrorPorcentualPromedio2 = mean(ErrorPorcentual2)

plot(test2[,38],valores_p2, xlab = "Real",ylab = "Pronostico")
abline(0,1, lty=2, col='blue') 




step(Regresion)

Regresion3 = lm(formula = 'pesoRacimo ~ Viento + SE + PORVL6N1 + PORVL8N1 + 
     PORVL16N1 + PORVL18N2 + PORVL24N1', data = train)
summary(Regresion3)


prediccion3 = predict(Regresion3, test, se.fit = TRUE)
valores_p3 = prediccion3$fit

Error3 = as.matrix(test[,38] - valores_p3) 

ecm3 = t(Error3)%*%Error3/1223

ind3 =  !(test[,38]  == 0)
ErrorPorcentual3 = 100*abs(test[ind3,38] - valores_p3[ind3])/test2[ind3,38]
ErrorPorcentualPromedio3 = mean(ErrorPorcentual3)

plot(test[,38],valores_p3, xlab = "Real",ylab = "Pronostico")
abline(0,1, lty=2, col='blue') 


