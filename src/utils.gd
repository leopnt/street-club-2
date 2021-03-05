extends Node

func map(value:float, istart:float, istop:float,ostart:float, ostop:float
) ->  float:
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
