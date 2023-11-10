%swipl -f sistema_experto_turismo.pl
%recomienda_lugar(LugarRecomendado).

% Hechos sobre lugares turísticos en Guadalajara
lugar(guadalajara, 'Guadalajara', 'Una hermosa ciudad en el occidente de México.', 'Guadalajara, Jalisco, México').
lugar(teatro_degollado, 'Teatro Degollado', 'Un hermoso teatro histórico.', 'Calle Belén 22, Zona Centro, Guadalajara, Jalisco, México').
lugar(zoologico_gdl, 'Zoológico de Guadalajara', 'Un zoológico con una gran variedad de animales.', 'Calle Paseo del Zoológico 600, Huentitán el Alto, Guadalajara, Jalisco, México').
lugar(tequila_tour, 'Tour del Tequila', 'Recorre las destilerías de tequila.', 'Tequila, Jalisco, México').
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

% Reglas para evaluar las respuestas del usuario
ha_visitado_guadalajara(SiHaVisitado) :-
    pregunta('¿Has visitado Guadalajara anteriormente?', ['si', 'no'], SiHaVisitado).

duracion_estadia(Duracion) :-
    pregunta('¿Cuánto tiempo estarás en la ciudad?', ['1_a_3_dias', '4_a_7_dias', 'mas_de_8_dias'], Duracion).

edad_visitante(Edad) :-
    pregunta('¿Para qué edad es el plan que busca?', ['de_1_a_12_anios', 'de_13_a_17_anios', 'de_18_a_40_anios', 'mas_de_40_anios'], Edad).

tipo_grupo(Grupo) :-
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