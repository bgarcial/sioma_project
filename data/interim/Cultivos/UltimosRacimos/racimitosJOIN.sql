SELECT R.peso, R.fecha,
L.nombre, L.numero, L.lat, L.lng,
F.nombre
FROM racimitos AS R
INNER JOIN viajes AS V ON V.viaje_id = R.viaje_id
INNER JOIN lotes AS L ON L.lote_id = V.lote_id
INNER JOIN fincas as F  ON F.finca_id = L.finca_id
WHERE F.finca_id=27 AND R.fecha BETWEEN "2018-07-27 00:00:00" AND "2018-08-03 23:59:59"
