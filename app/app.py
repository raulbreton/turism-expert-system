from flask import Flask, render_template, request
from subprocess import Popen, PIPE
import re

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/recomendar', methods=['POST'])
def recomendar():
    ha_visitado = request.form['ha_visitado']
    duracion = request.form['duracion']
    edad = request.form['edad']
    grupo = request.form['grupo']
    presupuesto = request.form['presupuesto']
    tipo_plan = request.form['tipo_plan']

    # Llama a SWI-Prolog desde Python
    prolog = Popen(['swipl', '-s', '/home/raulbreton/proyecto_prolog/sistema_experto_turismo.pl'], stdin=PIPE, stdout=PIPE, stderr=PIPE, text=True)
    query = f"recomienda_lugar('{ha_visitado}', '{duracion}', '{edad}', '{grupo}', '{presupuesto}', '{tipo_plan}', LugarRecomendado)."

    output, error = prolog.communicate(input=query)

    if output.strip() != "false.":
        lugar_recomendado = re.findall(r"'(.*?)'",output)[0]
    else:
        lugar_recomendado = "No hay lugares que mostrar en base a tus respuestas."

    return render_template('index.html', lugar_recomendado=lugar_recomendado)

if __name__ == '__main__':
    app.run(debug=True)
