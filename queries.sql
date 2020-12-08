--@ex2_base_8pm.sql

--Inicio del Script 
PROMPT ...............................................
PROMPT Examen #2, Curso: Implementacion de BD
PROMPT Profesor: Manuel Espinoza
PROMPT ...............................................
PROMPT .
PROMPT .
PROMPT Pregunta #1 a #6 (15 puntos cada una) 6x15 = 90 puntos
PROMPT Pregunta #7 y #8 (5 puntos cada una) 2x5 = 10 puntos
PROMPT Debe usar FORMATEO DE COLUMNAS, Debe colocar su nombre el inicio y al final (2 ptos menos si falta al inicio o al final)
PROMPT Tiempo Total 1.5 horas (con adecuación 2.5 horas) Subir al aula virtual
PROMPT Solo el archivo .sql SIN COMPRIMIR y con el nombre en minuscula (sin tildes ni letras especiales)
PROMPT ..
PROMPT Trabajar individual, de forma honesta no consultar a ninguna persona, puede usar scripts de ejemplo!
PROMPT ..todo es basado en Modelo Relacional de HR2 que hemos usado en lecciones.

host cls
--tamaños de linea y pagina
set linesize 200
set pagesize 200

PROMPT =========================================================================================================
PROMPT Estudiante: "luis venegas ulloa", 6PM (Archivo a Subir: ex2_luis_venegas.sql)
PROMPT 2 puntos MENOS. si no va con este formato, todo en minuscula sin tildes ni caracteres especiales
PROMPT   su nombre tanto al inicio como al final del script donde dice "Su nombre completo"
PROMPT =========================================================================================================
PROMPT .
PROMPT .
PROMPT .
PROMPT =========================================================================================================
PROMPT (1 punto menos por cada respuesta sin formateo de columnas Titulo EXACTO como se muestra en el ejemplo)
PROMPT Solo hay dos salidas (#2 y #4) que NO DEBE HACER FORMATEO DE COLUMNA para que el resultado salga bien! OJO!
PROMPT =========================================================================================================
PROMPT Haber ejecutado el script @hr2Prac2.sql (un par de veces)
PROMPT luego solo correr este script que hace selects, crea vistas y funciones. El Script no debe cambiar datos!
PROMPT Todo lo que hace este script es conectado como hr2 
PROMPT =========================================================================================================
PROMPT =========================================================================================================
PROMPT #0 Conectarse como hr/hr2 y Formateo de Columnas
conn hr2/hr123

--Formateo de Texto debe esta en esta parte del SCRIPT
column nombre                  HEADING Nombre            format A30
column ciudad                  HEADING Ciudad            format A20
column fec_final               HEADING Fec_Final         format A10
column txt_job                 HEADING Txt_Job           format A36
column tipo                    HEADING Tipo              format 999999
column puesto_depto            HEADING Puesto_Depto      format A50
column datos_puestos           HEADING Datos_Puestos     format A30
column datos_depto             HEADING Datos_Depto       format A30
column cant                    HEADING Cant              format 999
column salarios                HEADING Salarios          format 9999999
column id                      HEADING Id                format 9999
column nom_emp                 HEADING Nom_Emp           format A30
column nom_depto               HEADING Nom_Depto         format A20

--Inicio de los ejercicios
PROMPT =========================================================================================================
PROMPT 1) (15ptos) SELECT. Consultar el ID de region con alias "Tipo" y el nombre de la region
PROMPT UNIR con id de empleado y apellido (solo cuando apellido inicia con letra "W")
PROMPT ordenar por columna #1 ascendente
--**OJO** ACA INICIA LA PROGRAMACION, NO TOCAR NADA DE LO ANTERIOR!!!
--Iniciar en la siguiente línea

--**OJO** quitar este ejemplo es solo para explicar el formato
select r.region_id Tipo,r.region_name Nombre  from HR2.regions r
UNION
SELECT e.employee_id Tipo,e.last_name Nombre from HR2.employees e
where e.last_name like 'W%'
ORDER BY 1,2;






PROMPT =========================================================================================================
PROMPT 2) (15ptos) SELECT. Traer el PUESTO + " - " + NOMBRE DEPTO (del empleado), agrupar sobre la columna anterior
PROMPT y mostrar la cantidad de empleados, y sumar el salario, ordenar ascendente por la primer columna.
PROMPT 
--Iniciar en la siguiente línea
SELECT (j.job_title||'-'|| d.department_name) Puesto_Depto,count(e.employee_id)Cant,sum(e.salary)Salarios FROM HR2.departments d , HR2.jobs j,HR2.employees e
where d.department_id = e.department_id and e.job_id =j.job_id
GROUP BY j.job_title,d.department_name
ORDER BY 1;




PROMPT =========================================================================================================
PROMPT 3) (15ptos) FUNCTION. Funcion que cuente la cantidad de empleados que tiene a cargo el JEFE
PROMPT (El jefe de cada empleado es el campo MANAGER_ID)
PROMPT Recibe por parametro el ID de Jefe a buscar (cuando empleados tiene a cargo ese ID)
--Iniciar en la siguiente línea
  
create or replace function fun_can_emp(id_jefe in number) return number is
VCantLin number;
begin
  select count(*)
  into   VCantLin
  from    HR2.employees e1
  where  e1.manager_id=id_jefe;
  return (VCantLin );
end fun_can_emp;
/
show error

PROMPT 3.1) VIEW. Crear una vista que muestre el id del empleado, el nombre del empleado y
PROMPT usar la funcion anterior para pasar por parametro el JEFE de cada empleado consultado (cada fila), para ver 
PROMPT la cantidad de empleados que tiene a cargo ese JEFE. 
--Iniciar en la siguiente línea
create or replace view vista_con_jefe as
SELECT e.employee_id Id,e.first_name Nom_Emp,fun_can_emp(e.manager_id)Cant
FROM   HR2.employees e;


PROMPT 3.2) Y hacer select de la vista anterior cuando el ID de empleado sea menor a 120 (ordenar por ID de emp ascendente
--Iniciar en la siguiente línea
select *from vista_con_jefe
where Id <120
ORDER BY 1;


PROMPT =========================================================================================================
PROMPT 4) (15ptos) SELECT. Hacer consulta que muestre ID de empleado, porcentaje de comision (COMMISSION_PCT),
PROMPT el salario, y la ultima columna es: la suma del porcentaje de comision MAS salario pero
PROMPT en caso que el porcentaje de comision sea nulo debe asumirlo como valor numerico 1 (uno) para poderlo sumar.
PROMPT Mostrar para los empleados de ID desde 143 a 147 (ambos inclusive) ordenado ascendente por id de empleado
PROMPT Ni "COMI" ni "SUM_COMI" tienen formateo de columnas 
PROMPT segun su configuracion algunos valores puede verse como "14000,4" o bien "14000.4" (no hay problema)
--Iniciar en la siguiente línea

select e.employee_id Id, e.commission_pct COMI, e.salary Salarios, 
nvl(e.commission_pct, 1) + e.salary SUM_COMI
from HR2.employees e
where e.employee_id >= 143 and e.employee_id <= 147 order by 1 asc;


PROMPT =========================================================================================================
PROMPT 5) (15ptos) SELECT. Producto cartesiano (1x1x1) para mostrar la combinacion exacta como se muestra esta consulta
PROMPT Debe usar las 3 tablas: JOB_HISTORY, DEPARTAMENTOS y LOCALIZACIONES.
PROMPT el primer campo es END_DATE de la tabla JOB_HISTORY, luego el nombre de departamento y la ciudad
PROMPT el estudiante hace la condicion de WHERE para mostrar este resultado usando las 3 tablas antes indicadas!
--Iniciar en la siguiente línea
SELECT TO_CHAR(h.end_date,'dd-mm-yyyy') Fec_Final,d.department_name Nom_Depto,l.city Ciudad
from HR2.job_history h,HR2.departments d,HR2.locations l
WHERE TO_CHAR(h.end_date,'dd-mm-yyyy')= '24-07-1998' 
and d.department_id=70 and l.location_id=1800 ;




PROMPT =========================================================================================================
PROMPT 6) (15ptos) SELECT. Hacer una consulta sobre JOB_HISTORY mostrar el ID de empleado, la palabra fija
PROMPT "Inicio " y unir texto con START_DATE (con el formato indicado) y la palabra " Final "
PROMPT con la fecha del campo END_DATE  (con el formato indicado)
PROMPT ordenar por el primer campo, luego por el segundo (ambos ascendente)
--Iniciar en la siguiente línea
select j.employee_id Id, 'Inicio'||' '||to_char(j.start_date,'dd-mm-yyyy')||' '||'Final'||' '||to_char(j.end_date,'dd-mm-yyyy') Txt_Job
from HR2.job_history j order by 1, 2 asc;


PROMPT =========================================================================================================
PROMPT 7) (5ptos) FUNCTION. Crear funcion que reciba dos codigos de puesto, y retorne la cantidad de empleados
PROMPT que estan en JOB_HISTORY con esos codigos de puestos, y retornarlo.
PROMPT Puede que un codigo de puesto tenga 2 y el otro 0 (entonces retorna 2 que es la suma de ambos!)
--Iniciar en la siguiente línea
create or replace function can_por_p (pid1 in VARCHAR2, pid2 in VARCHAR2) return number is
 VCan number;
begin
  select count(j.job_id)
  into   VCan
  from   HR2.job_history j
  where  j.job_id = pid1 or j.job_id = pid2;
  return (VCan);
end can_por_p;
/
show error



PROMPT Estas pruebas son para comprobar, debe dejarlas con los mismos valores del ejemplo
PROMPT usando el nombre de la funcion que ha creado el estudiante
PROMPT 7.1 Pruebas de la funcion con valores de ('ST_CLERK','AC_ACCOUNT') 
PROMPT Ejemplo 7.1) : select fun_NOMBRE('ST_CLERK','AC_ACCOUNT') cant from dual;

--**OJO** quitar comentario de abajo y colocar nombre de funcion correcto!
select can_por_p('ST_CLERK','AC_ACCOUNT') cant from dual;



PROMPT 7.2 Pruebas de la funcion con valores de ('IT_PROG','AD_ASST')
PROMPT Ejemplo 7.2) : select fun_NOMBRE('IT_PROG','AD_ASST') cant from dual;

--**OJO** quitar comentario de abajo y colocar nombre de funcion correcto!
select can_por_p('IT_PROG','AD_ASST') cant from dual;

PROMPT =========================================================================================================
PROMPT 8) (5ptos) FUNCTION. Crear funcion que reciba ID de departamento y muestre el texto como se
PROMPT muestra en el ejemplo abajo (ID + valor de id + nombre del departamento)
--Iniciar en la siguiente línea
create or replace function texto_id(pid1 in NUMBER) return VARCHAR2 is
 VCan VARCHAR2(40);
begin
  select ('ID :'||to_char(pid1)| |' '||d.department_name)
  into   VCan
  from    HR2.departments d
  where   d.department_id=pid1 ;
  return (VCan);
end texto_id;
/
show error






PROMPT Estas pruebas son para comprobar, debe dejarlas con los mismos valores del ejemplo 
PROMPT usando el nombre de la funcion que ha creado el estudiante
--Dejar estas pruebas solo con fun_NOMBRE
PROMPT 8.1 Prueba con ID #10:  Ej: select fun_NOMBRE(10) datos_depto from dual;


--**OJO** quitar comentario de abajo y colocar nombre de funcion correcto!
select texto_id(10) datos_depto from dual;

--Dejar estas pruebas solo con fun_NOMBRE
PROMPT 8.2 Prueba con ID #20:  Ej: select fun_NOMBRE(20) datos_depto from dual;

--**OJO** quitar comentario de abajo y colocar nombre de funcion correcto!
select texto_id(20) datos_depto from dual;

PROMPT =========================================================================================================
PROMPT Estudiante: "luis venegas", 6PM (Archivo a Subir: ex2_luis_venegas.sql)
PROMPT =========================================================================================================
--Fin del Script