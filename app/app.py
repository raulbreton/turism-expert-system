from flask import Flask, render_template, request
from subprocess import Popen, PIPE
import re

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/recomendar', methods=['POST'])
def recomendar():
    #Save user input
    ha_visitado = request.form['ha_visitado']
    duracion = request.form['duracion']
    edad = request.form['edad']
    grupo = request.form['grupo']
    presupuesto = request.form['presupuesto']
    tipo_plan = request.form['tipo_plan']

    # Calls SWI-Prolog from Python
    prolog = Popen(['swipl', '-s', '/home/raulbreton/proyecto_prolog/sistema_experto_turismo.pl'], stdin=PIPE, stdout=PIPE, stderr=PIPE, text=True)
    query = f"recomienda_lugar('{ha_visitado}', '{duracion}', '{edad}', '{grupo}', '{presupuesto}', '{tipo_plan}', LugarRecomendado)."

    output, error = prolog.communicate(input=query)

    #Checks if there is a recomendation as a result
    if output.strip() != "false.":
        lugar_recomendado = re.findall(r"'(.*?)'",output)[0]
        #Get Site Info
        prolog = Popen(['swipl', '-s', '/home/raulbreton/proyecto_prolog/sistema_experto_turismo.pl'], stdin=PIPE, stdout=PIPE, stderr=PIPE, text=True)
        query_info = f"obtener_info_lugar('{lugar_recomendado}')."
        output_info, error_info = prolog.communicate(input=query_info)
        # Filter out the 'true.' value and join the strings
        lugar_info = output_info.split('\n')
        lugar_info = [info for info in lugar_info if info != 'true.']
        lugar_info = [linea for linea in lugar_info if linea.strip()]
        #formatted_lugar_info = ' '.join(lugar_info)
        return render_template('index.html', lugar_recomendado=lugar_info)
    else:
        lugar_recomendado = ["No hay lugares que mostrar en base a tus respuestas."]
        return render_template('index.html', lugar_recomendado=None)

if __name__ == '__main__':
    app.run(debug=True)