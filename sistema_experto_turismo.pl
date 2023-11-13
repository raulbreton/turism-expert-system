%swipl -f sistema_experto_turismo.pl
%recomienda_lugar(LugarRecomendado).

%Tener para obtener informacion de un lugar
obtener_info_lugar(NombreLugar) :-
    lugar(_, NombreLugar, Descripcion, Direccion),
    write('Nombre del lugar: '), write(NombreLugar), nl,
    write('Descripción: '), write(Descripcion), nl,
    write('Dirección: '), write(Direccion), nl.

% Hechos sobre lugares turísticos en Guadalajara
lugar(teatro_degollado, 'Teatro Degollado', 'Un hermoso teatro histórico.', 'Calle Belén 22, Zona Centro, Guadalajara, Jalisco, México').
lugar(vulcanos_pizza, 'Vulcanos Pizza', 'Lugar de pizzas estilo chicago', 'Av La Paz 1766, Colonia Americana / Av. Paseo la Toscana 777, Valle Real').
lugar(casa_tequila, 'Casa de Tequila', 'Casa de Catación de Tequíla', 'Kilometro 32.2, 45350 El Arenal, Jal.').
lugar(casa_tequila, 'El Gallo Altanero', 'El bar con reconocimiento internacional.', 'Calle Marsella 126, Col Americana, Lafayette, 44160 Guadalajara, Jal.').
lugar(casa_tequila, 'Selva Mágica', 'Parque de Diversiones Tapatío', 'C. P.º del Zoológico 600, Huentitán El Bajo, 44390 Guadalajara, Jal.').
lugar(casa_tequila, 'Cámara de Comercio de Guadalajara', 'Centro de Negocios de Turismo y Servicios', 'Av. Ignacio L Vallarta 4095, Don Bosco Vallarta, 45040 Zapopan, Jal.').
% Agrega más lugares aquí con sus respectivos hechos.

% Reglas para recomendar lugares
recomienda_lugar(Sugerencia) :-
    ha_visitado_guadalajara(SiHaVisitado),
    duracion_estadia(Duracion),
    edad_visitante(Edad),
    tipo_grupo(Grupo),
    presupuesto(Disponibilidad),
    tipo_plan(TipoPlan),
    lugar_recomendado(SiHaVisitado, Duracion, Edad, Grupo, Disponibilidad, TipoPlan, Sugerencia).

% Regla para recomendar un lugar con todos los argumentos directos
recomienda_lugar(SiHaVisitado, Duracion, Edad, Grupo, Disponibilidad, TipoPlan, LugarRecomendado) :-
lugar_recomendado(SiHaVisitado, Duracion, Edad, Grupo, Disponibilidad, TipoPlan, LugarRecomendado).

% Regla para determinar el lugar recomendado
lugar_recomendado('si', '1_a_3_dias', 'de_1_a_12_anios', 'pareja', 'menos_de_1000_MXN', 'descanso', 'Teatro Degollado').
lugar_recomendado('si', 'mas_de_8_dias', 'de_18_a_40_anios', 'pareja', 'mas_de_1000_MXN','descanso', 'Vulcanos Pizza').
lugar_recomendado('no', '4_a_7_dias', 'de_18_a_40_anios', 'amigos', 'mas_de_1000_MXN', 'fiesta','Casa de Tequila').
lugar_recomendado('si', '4_a_7_dias', 'de_18_a_40_anios', 'amigos', 'mas_de_1000_MXN', 'fiesta','El Gallo Altanero').
lugar_recomendado('si', '4_a_7_dias', 'de_13_a_17_anios', 'familia', 'mas_de_1000_MXN', 'fiesta','Selva Mágica').
lugar_recomendado('si', 'mas_de_8_dias', 'de_18_a_40_anios', 'negocios', 'menos_de_1000_MXN', 'cultural','Cámara de Comercio de Guadalajara').
% Reglas para evaluar las respuestas del usuario
ha_visitado_guadalajara(SiHaVisitado) :-
    pregunta('¿Has visitado Guadalajara anteriormente?', ['si', 'no'], SiHaVisitado).

duracion_estadia(Duracion) :-
    pregunta('¿Cuánto tiempo estarás en la ciudad?', ['1_a_3_dias', '4_a_7_dias', 'mas_de_8_dias'], Duracion).

edad_visitante(Edad) :-
    pregunta('¿Para qué edad es el plan que busca?', ['de_1_a_12_anios', 'de_13_a_17_anios', 'de_18_a_40_anios', 'mas_de_40_anios'], Edad).

tipo_grupo(Grupo) :-mas_de_8_dias
    pregunta('¿Para qué clase de grupo es el plan?', ['pareja', 'familia', 'amigos', 'negocios'], Grupo).

presupuesto(Disponibilidad) :-
    pregunta('¿De qué presupuesto dispones el plan?', ['gratis', 'menos_de_1000_MXN', 'mas_de_1000_MXN'], Disponibilidad).

tipo_plan(TipoPlan) :-
    pregunta('¿A qué tipo de plan te gustaría ir?', ['descanso', 'cultural', 'extremo', 'shopping', 'fiesta'], TipoPlan).

% Regla para realizar preguntas al usuario
pregunta(Pregunta, Opciones, Respuesta) :-
    nl,
    write(Pregunta), nl,
    listar_opciones(Opciones),
    read(Respuesta),
    validar_respuesta(Respuesta, Opciones).

% Regla para listar las opciones de respuesta
listar_opciones([]).
listar_opciones([Opcion | Resto]) :-
    write('- '), write(Opcion), nl,
    listar_opciones(Resto).

% Regla para validar la respuesta del usuario
validar_respuesta(Respuesta, Opciones) :-
    (atom(Respuesta); string(Respuesta)),
    member(Respuesta, Opciones),
    !.
validar_respuesta(Respuesta, Opciones) :-
    write('Respuesta no válida. Por favor, elige una opción válida.'), nl,
    pregunta(_, Opciones, Respuesta).