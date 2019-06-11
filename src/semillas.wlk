class Planta {
	const property anioSemilla
	const property altura
	
	constructor(_anioSemilla, _altura) {
		anioSemilla= _anioSemilla
		altura = _altura
	}
	
	method esFuerte() = self.horasSolTolera() > 10
	
	method horasSolTolera()
	method nuevasSemillas() = self.esFuerte()
	method espacioPlantada()
	method resultaIdeal(parcela)
	method seAsociaBien(parcela) = parcela.seAsociaBien(self)
}

class Menta inherits Planta {
	
	override method horasSolTolera() = 6 
	
	//no se incluye "super() or" ya que las horas de sol "6" no superan las 10 de "esFuerte()" por ende siempre depende de la altura.
	override method nuevasSemillas() = altura > 0.4  
	
	override method espacioPlantada() = altura * 3
	
	override method resultaIdeal(parcela) = parcela.superficie() > 6
}

class Soja inherits Planta {
	
	override method horasSolTolera() {
		return if (altura < 0.5) 6 
				else if (altura.between(0.5 , 1)) 7
					else 9		
		}
	
	//no va "super() or" ya que nunca llega a ser fuerte por no tolerar mas de 10 horas de sol diarias	 
	override method nuevasSemillas() = anioSemilla > 2007 and altura > 1
		
	override method espacioPlantada() = altura / 2
	override method resultaIdeal(parcela) = self.horasSolTolera() == parcela.horasSolPorDia()
}

class Quinoa inherits Planta {
	const horasSolTolera
	
	constructor(_anioSemilla, _altura,_horasSolTolera) =
		super(_anioSemilla, _altura) {
		horasSolTolera= _horasSolTolera
	}
		
	override method horasSolTolera() = horasSolTolera
	override method nuevasSemillas() = super() or anioSemilla < 2005
	
	override method espacioPlantada() = 0.5
	override method resultaIdeal(parcela) = not parcela.alturaPlantaMasGrande() > 1.5 	
}

class HierbaBuena inherits Menta {
	override method espacioPlantada() = super() * 2
}

class SojaTransgenica inherits Soja {
	override method nuevasSemillas() = false
	override method resultaIdeal(parcela) = parcela.maximaCantPlanta() == 1
}

class Parcela {
	const largo
	const ancho
	const property horasSolPorDia
	const plantas = []
	
	method superficie() = largo * ancho
	method maximaCantPlantas() {
		return if (ancho > largo) self.superficie() / 5
				else self.superficie() / 3 + largo
	}
	
	method noHayMasLugar() = self.totalPlantas() == self.maximaCantPlantas()
		
	method tieneComplicaciones() = plantas.any({unaPlanta => unaPlanta.horasSolTolera() < horasSolPorDia}) 
	
	method totalPlantas() = plantas.size()
	
	method planta(unaPlanta) { 
		if (self.noHayMasLugar() or horasSolPorDia >= unaPlanta.horasSolTolera() + 2) plantas.add(unaPlanta)
		else throw new Exception("No hay más espacio!")
	}
	
	method plantaMasGrande() = plantas.max({unaPlanta => unaPlanta.altura()})
	method alturaPlantaMasGrande() = self.plantaMasGrande().altura()
	method seAsociaBien(planta)
	method promedioBienAsociadas() = plantas.filter({unaPlanta  => unaPlanta.seAsociaBien(self)}).size() / self.totalPlantas()
}

class ParcelaEcologica inherits Parcela {
	override method seAsociaBien(planta) = not self.tieneComplicaciones() and planta.resultaIdeal(self) 	
}

class ParcelaIndustrial inherits Parcela {
	override method seAsociaBien(planta) = self.maximaCantPlantas() == 2 and planta.esFuerte()
}

object inta {
	const parcelas = []

	method promedioDePlantas() = parcelas.sum({unaParcela => unaParcela.totalPlantas()}) / parcelas.size()
	method parcelaMasAutosustentable() = parcelas.filter({unaParcela.totalPlantas() > 4}).max({unaParcela => unaParcela.promedioAsociaBien()})
	method agregarParcela(unaParcela) { parcelas.add(unaParcela)}
	 
}